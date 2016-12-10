$ErrorActionPreference = 'Stop';

$packageName  = 'WinDirStat'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'windirstat1_1_2_setup.exe'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'WinDirStat*'
  file          = $fileLocation
  fileType      = 'exe'
  silentArgs    = "/S"
  validExitCodes= @(0)
  checksum      = '370A27A30EE57247FADDEB1F99A83933247E07C8760A07ED82E451E1CB5E5CDD'
  checksumType  = 'sha256'
}

Install-ChocolateyInstallPackage @packageArgs
