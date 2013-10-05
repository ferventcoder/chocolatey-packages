$packageName = 'vim'
$fileType = 'exe'
$args = '/S'
$url = 'http://downloads.sourceforge.net/project/cream/Vim/7.4.27/gvim-7-4-27.exe'

Install-ChocolateyPackage $packageName $fileType $args $url

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Start-ChocolateyProcessAsAdmin (Join-Path $scriptDir 'chocolateyPostInstallUAC.ps1')
