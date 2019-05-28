$ErrorActionPreference = 'Stop';

# Currently, version number information is taking from here:
# https://s3.amazonaws.com/prerelease.keybase.io/update-windows-prod-v2.json

$packageArgs = @{
  packageName            = "$env:chocolateyPackageName"
  softwareName           = 'Keybase*'
  FileType               = 'msi'
  SilentArgs             = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  url                    = 'https://prerelease.keybase.io/windows/Keybase_4.0.0-20190507155043%2B6614a49937.amd64.msi'
  checksum               = 'A7F765D838C449A5B789FD1D4E78E2DA49EC4F1108519827651CF9058E98BCB4'
  checksumType           = 'sha256'
  validExitCodes         = @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs
