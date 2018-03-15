$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName            = "$env:chocolateyPackageName"
  softwareName           = 'Keybase*'
  FileType               = 'exe'
  SilentArgs             = '/quiet'
  url                    = 'https://prerelease.keybase.io/keybase_setup_386.exe'
  checksum               = '89d876b3188b44b702e7e9cbcb0290b543ea1639d01a9cbd1d0328e479399a28'
  checksumType           = 'sha256'
}
Install-ChocolateyPackage @packageArgs
