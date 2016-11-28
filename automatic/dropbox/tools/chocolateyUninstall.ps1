Import-Module (Join-Path $PSScriptRoot 'Helpers.psm1')

$packageName = 'dropbox'
$fileType = 'exe'
$silentArgs = '/S'
$uninstallerPath = (GetDropboxRegProps).UninstallString

if ($uninstallerPath) {
  Uninstall-ChocolateyPackage $packageName $fileType $silentArgs $uninstallerPath
}