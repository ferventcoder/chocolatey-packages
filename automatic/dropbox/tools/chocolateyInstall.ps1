$script           = $MyInvocation.MyCommand.Definition
$packageName      = 'Dropbox'
$installer        = Join-Path (GetParentDirectory $script) 'Dropbox 14.4.19 Offline Installer.exe'
$url              = 'https://clientupdates.dropboxstatic.com/client/Dropbox%2014.4.19%20Offline%20Installer.exe'
$packageArgs      = @{
  packageName     = $packageName
  unzipLocation   = (GetCurrentDirectory $script)
  fileType        = 'exe'
  file            = $installer
  url             = $url
  softwareName    = 'Dropbox*'
  checksum        = 'A0827474448EF4EC4E65D61E00757F7812DF9E9004B6D944FDEDEDE6D88DEFE7'
  checksumType    = 'sha256'
  silentArgs      = '/s'
  validExitCodes  = @(0, 3010, 1641)
}

InstallFromLocalOrRemote $packageArgs

Stop-Process -processname Dropbox