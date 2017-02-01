$ErrorActionPreference = 'Stop';

$packageName  = 'curl'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'curl-7.52.1-x86.zip'
$fileLocation64 = Join-Path $toolsDir 'curl-7.52.1-x64.zip'
if (Get-ProcessorBits 64) {
$forceX86 = $env:chocolateyForceX86
  if ($forceX86 -eq 'true') {
    Write-Debug "User specified '-x86' so forcing 32-bit"
  } else {
    $fileLocation = $fileLocation64
  }
}

$packageArgs = @{
  packageName   = $packageName
  file          = $fileLocation
  checksum      = '4D4673A149B3D7568804F00395A5A359ABA126EDD481E2F120C47C201847C2DF'
  checksumType  = 'sha256'
  checksum64    = '43286996301376C31FD7669E39349BDEF5DD9EE3FA8A6BE4D356794AF605A2A4'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

# If the version of Chocolatey is less than 0.10.1, Get-ChocolateyUnzip needs `fileFullPath`.
if ((New-Object System.Version $env:CHOCOLATEY_VERSION) -le (New-Object System.Version '0.10.0')) {
  $packageArgs["fileFullPath"] = $fileLocation
}

Get-ChocolateyUnzip @packageArgs

