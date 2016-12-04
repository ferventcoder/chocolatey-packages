$script           = $MyInvocation.MyCommand.Definition
$packageName      = 'Dropbox'
$installer        = Join-Path (GetParentDirectory $script) 'Dropbox 15.4.22 Offline Installer.exe'
$url              = 'https://www.dropbox.com/downloading?full=1&os=win'
$packageArgs      = @{
  packageName     = $packageName
  unzipLocation   = (GetCurrentDirectory $script)
  fileType        = 'exe'
  file            = $installer
  url             = $url
  softwareName    = 'Dropbox*'
  checksum        = '46CC8743A1B9BA3BD36799AFE09F7E9BDDA9B7D1F434B3874494BAC02E1757E8'
  checksumType    = 'sha256'
  silentArgs      = '/s'
  validExitCodes  = @(0, 3010, 1641)
}

InstallFromLocalOrRemote $packageArgs

Stop-Process -processname Dropbox