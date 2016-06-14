$packageName= 'synergy'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url   = "http://symless.com/download/file?file=synergy-1.4.18-r2250-Windows-x86.msi"
$url64 = "http://symless.com/download/file?file=synergy-1.4.18-r2250-Windows-x64.msi"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'Synergy*'
  checksum      = ''
  checksumType  = 'md5' #default is md5, can also be sha1
  checksum64    = ''
  checksumType64= 'md5' #default is checksumType
}

Install-ChocolateyPackage @packageArgs
