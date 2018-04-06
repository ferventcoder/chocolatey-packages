$ErrorActionPreference = 'Stop';

# Currently, version number information is taking from here:
# http://s3.amazonaws.com/prerelease.keybase.io/update-windows-prod-v2.json

$packageArgs = @{
  packageName            = "$env:chocolateyPackageName"
  softwareName           = 'Keybase*'
  FileType               = 'exe'
  SilentArgs             = '/quiet'
  url                    = 'https://prerelease.keybase.io/windows/Keybase_1.0.47-20180404145203%2B0fe66b9.386.exe'
  checksum               = '90E4AB31AB2A93BF4F3DFA90A89C24BD23ADFED331545C0606CE459A394FE3FF'
  checksumType           = 'sha256'
  validExitCodes         = @(0, 3010)
}
Install-ChocolateyPackage @packageArgs
