$packageName = 'grepwin'
$installerType = 'msi'
$installArgs = '/quiet'
$url = 'https://sourceforge.net/projects/grepwin/files/1.7.0/grepWin-1.7.0.msi/download'
$url64 = 'https://sourceforge.net/projects/grepwin/files/1.7.0/grepWin-1.7.0-x64.msi/download'

Install-ChocolateyPackage $packageName $installerType $installArgs $url $url64
