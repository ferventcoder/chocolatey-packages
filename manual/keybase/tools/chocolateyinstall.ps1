$ErrorActionPreference = 'Stop';

# Currently, version number information is taking from here:
# https://s3.amazonaws.com/prerelease.keybase.io/update-windows-prod-v2.json

$packageArgs = @{
  packageName            = "$env:chocolateyPackageName"
  softwareName           = 'Keybase*'
  FileType               = 'msi'
  SilentArgs             = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  url                    = 'https://prerelease.keybase.io/windows/Keybase_4.2.0-20190710141157%2Be7c0bdc4a2.amd64.msi'
  checksum               = '02a759ec9c70a21d27b4b10eb5d5ccd2e61ea00eeec48480ba7b44641905ff04'
  checksumType           = 'sha256'
  validExitCodes         = @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs
