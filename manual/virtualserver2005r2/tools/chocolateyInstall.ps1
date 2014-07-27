$packageName = 'virtualserver2005r2'
$installerType = 'msi'
$url = 'http://download.microsoft.com/download/d/7/2/d7235926-a10d-482c-a2ff-6e0d3130f869/32-BIT/setup.exe'
$url64 = 'http://download.microsoft.com/download/d/7/2/d7235926-a10d-482c-a2ff-6e0d3130f869/64-BIT/setup.exe'
#http://my.safaribooksonline.com/book/operating-systems-and-server-administration/virtualization/9780735623811/installing-virtual-server-2005-r2-sp1/ch04lev1sec7
$silentArgs = '/quiet /norestart NOSUMMARY=1 ADDLOCAL="VirtualServer,VMRCClient,VSWebApp,VHDMount"'
$validExitCodes = @(0, 3010)

try {
  # http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
  $osVersion = [Environment]::OSVersion.Version
  if ($osVersion -ge [Version]'6.0')
  {
    Write-ChocolateyFailure $packageName "$packageName not supported on your OS. It is only supported on Windows Server 2003."
    return
  }

  $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $downloadedFile = Join-Path "$toolsDir" 'VirtualServer2005R2.Setup.exe'

  Get-ChocolateyWebFile "$packageName" "$downloadedFile" "$url" "$url64"
  # Extract
  $virtualServerDir = Join-Path "$toolsDir" 'VirtualServer'
  & "$downloadedFile" /c /t "$virtualServerDir"
  Start-Sleep 2

  $extractedMsi = Join-Path "$virtualServerDir" 'Virtual Server 2005 Install.msi'
  # Stop running services
  #Net Stop "Virtual Server"
  #Net Stop VMH

  Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" "$extractedMsi" -validExitCodes $validExitCodes

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
