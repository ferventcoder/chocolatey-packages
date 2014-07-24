$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageName = 'Powershell4'
$installerType = 'msu'
$url   = 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x86-MultiPkg.msu'
$url64 = 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x64-MultiPkg.msu'
$urlWin2012 = 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows8-RT-KB2799888-x64.msu'
$silentArgs = "/quiet /norestart /log:`"$toolsDir\PowerShell.v4.Install.log`""
$validExitCodes = @(0, 3010) # 2359302 occurs if the package is already installed.

try
{
  if ($PSVersionTable -and ($PSVersionTable.PSVersion -ge [Version]'4.0'))
  {
    Write-ChocolateySuccess "$packageName already installed on your OS."
    return
  }

  # http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
  $osVersion = [Environment]::OSVersion.Version
  if ($osVersion -lt [Version]'6.1')
  {
    Write-ChocolateyFailure $packageName "$packageName not supported on your OS."
    return
  } elseif ($osVersion -ge [Version]'6.2') {
    $url64 = $urlWin2012

    $installType = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion","InstallationType","")
    if ($installType -eq 'Client') {
      Write-ChocolateyFailure $packageName "$packageName not supported on your OS. You must upgrade to Windows 8.1 to get WMF 4.0."
      return
    }
  } elseif ($osVersion -ge [Version]'6.3') {
    Write-ChocolateySuccess "$packageName already installed by default on your OS."
    return
  }

  Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

  Write-Warning "$packageName requires a reboot to complete the installation."
  Write-ChocolateySuccess $packageName
}
catch
{
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
}
