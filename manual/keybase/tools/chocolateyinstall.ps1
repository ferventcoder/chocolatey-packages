$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Keybase*'
  fileType      = 'exe'
  silentArgs    = "/install /quiet /norestart"
  validExitCodes= @(0)
  url           = "https://prerelease.keybase.io/keybase_setup_386.exe"
  checksum      = '357506406C23C67DA6845893368237482641C0ED9201FD27845ECE205208C9C1'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs

