$packageName = 'vagrant-winrm-config'

try {
  #$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  #$WinRMConfiguration = Join-Path "$toolsDir" "setwinrmconfig.ps1"
  #Start-ChocolateyProcessAsAdmin "& $WinRMConfiguration"

  $WinRMSvcName = 'WinRM'
  $FireWallSvcName = 'MpsSvc'
  $FWSvcMode = $null

  #Write-Host "Ensuring Required Services are Setup Correctly"
  #Get-Service 'DcomLaunch','RpcSs','RpcEptMapper','BFE' | Set-Service -StartupType Automatic -PassThru | Start-Service

  $FirewallSvc = Get-WmiObject Win32_Service | ? {$_.Name -eq $FireWallSvcName}
  if ($FirewallSvc -ne $null) {
    $FWSvcMode = $FirewallSvc.StartMode
    if($FirewallSvc.StartMode -eq 'Disabled') {
      Write-Host "Enabling Firewall Service to set WinRM config"
      Set-Service $FireWallSvcName -StartupType Manual
    }
    if ($FirewallSvc.State -eq 'Stopped') {
      Write-Host "Starting Windows Firewall Service"
      Start-Service $FireWallSvcName
    }
  }

  Write-Host 'Setting WinRM Service Configuration'
  Set-Service $WinRMSvcName -StartupType Automatic
  Start-Service $WinRMSvcName

  &winrm "quickconfig" "-q"
  &winrm "set" "winrm/config/winrs" "@{MaxMemoryPerShellMB=`"512`"}"
  &winrm "set" "winrm/config" "@{MaxTimeoutms=`"1800000`"}"
  &winrm "set" "winrm/config/service" "@{AllowUnencrypted=`"true`"}"
  &winrm "set" "winrm/config/service/auth" "@{Basic=`"true`"}"

  # http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
  $osVersion = [Environment]::OSVersion.Version
  if ($osVersion -lt [Version]'6.1')
  {
    Write-Host "Ensuring WinRM Port 5985 is opened"
    #&netsh "firewall" "add" "portopening" "TCP" "47001" "`"WinRM Port 47001`""
    &netsh "firewall" "add" "portopening" "TCP" "5985" "`"WinRM Port 5985`""
    Write-Host "Setting HTTP Transport for WinRM to Port 5985"
    &winrm "set" "winrm/config/listener?Address=*+Transport=HTTP" "@{Port=`"5985`"}"
  }

  Write-Host 'Ensuring WinRM Service Startup Mode is Automatic'
  Set-Service $WinRMSvcName -StartupType Automatic

  if ($FWSvcMode -ne $null -and $FWSvcMode -eq 'Disabled') {
    Write-Host "Stopping and disabling Firewall Service since it started that way"
    Get-Service $FireWallSvcName | Stop-Service -PassThru | Set-Service -StartupType Disabled
  }

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}

