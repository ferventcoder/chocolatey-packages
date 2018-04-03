$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName            = "$env:chocolateyPackageName"
  softwareName           = 'Keybase*'
  FileType               = 'exe'
  SilentArgs             = '/quiet'
  url                    = 'https://prerelease.keybase.io/windows/Keybase_1.0.47-20180402191728%2B19ebebe.386.exe'
  checksum               = '4163F6D6BAC8E58559E62240D61FEBD469E99D10A7E69D4CACEAB826EC824B3B'
  checksumType           = 'sha256'
  validExitCodes         = @(0, 3010)
}
Install-ChocolateyPackage @packageArgs
