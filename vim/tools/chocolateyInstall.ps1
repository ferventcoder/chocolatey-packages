$packageName = 'vim'
$fileType = 'exe'
$args = '/S'
$url = 'http://downloads.sourceforge.net/project/cream/Vim/7.4.205/gvim-7-4-205.exe'
$checksum = 'AD555321E99BF50900C1C4CC84570232'

Install-ChocolateyPackage $packageName $fileType $args $url -checksum "$checksum"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Start-ChocolateyProcessAsAdmin (Join-Path $scriptDir 'chocolateyPostInstallUAC.ps1')
