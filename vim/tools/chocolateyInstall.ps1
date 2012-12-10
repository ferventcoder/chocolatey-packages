$packageName = 'vim'
$fileType = 'exe'
$args = '/S'
$url = 'http://downloads.sourceforge.net/project/cream/Vim/7.3.736/gvim-7-3-736.exe'

Install-ChocolateyPackage $packageName $fileType $args $url

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Start-ChocolateyProcessAsAdmin (Join-Path $scriptDir 'chocolateyPostInstallUAC.ps1')