$ErrorActionPreference = 'Stop';

$packageName= 'InstEd'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://apps.instedit.com/releases2/InstEd-1.5.15.26.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'InstEd*'
  checksum      = 'e9893ddde47216bf812f8a6ba0ff607204dbcba2'
  checksumType  = 'sha1'
}

Install-ChocolateyPackage @packageArgs