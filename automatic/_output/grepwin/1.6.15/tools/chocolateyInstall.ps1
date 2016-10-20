$packageName = 'grepwin'
$installerType = 'msi'
$installArgs = '/quiet'
$url = 'https://sourceforge.net/projects/grepwin/files/1.6.15/grepWin-1.6.15.msi/download'
$url64 = 'https://sourceforge.net/projects/grepwin/files/1.6.15/grepWin-1.6.15-x64.msi/download'

Install-ChocolateyPackage $packageName $installerType $installArgs $url $url64
