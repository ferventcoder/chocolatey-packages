$packageName= 'synergy'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url   = "http://synergy-project.org/files/packages/synergy-v1.7.5-stable-fa85a24-Windows-x86.msi"
$url64 = "http://synergy-project.org/files/packages/synergy-v1.7.5-stable-fa85a24-Windows-x64.msi"

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