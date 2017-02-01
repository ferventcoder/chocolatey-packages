$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName   = 'visualstudiocode.portable'
  url           = "https://go.microsoft.com/fwlink/?LinkID=623231"
  checksum      = '672B200B79226A1A5CBF5C342C65A8CB052B72C2E9DA8F0BC41DD6FE4C6B0DB7'
  checksumType  = 'sha256'
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs

