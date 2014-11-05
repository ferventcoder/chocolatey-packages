$packageName = 'vim'
$fileType = 'exe'
$args = '/S'
$version = '7.4.493'
$versionDash = $version -replace '\.', '-'

$url = "http://sourceforge.net/projects/cream/files/Vim/${version}/gvim-${versionDash}.exe/download"

Install-ChocolateyPackage $packageName $fileType $args $url

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Start-ChocolateyProcessAsAdmin (Join-Path $scriptDir 'chocolateyPostInstallUAC.ps1')
