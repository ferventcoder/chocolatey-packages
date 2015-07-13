$packageName = 'grepwin'
$installerType = 'msi'
$installArgs = '/quiet'
$url = 'http://sourceforge.net/projects/grepwin/files/{{PackageVersion}}/grepWin-{{PackageVersion}}.msi/download'
$url64 = 'http://sourceforge.net/projects/grepwin/files/{{PackageVersion}}/grepWin-{{PackageVersion}}-64.msi/download'

Install-ChocolateyPackage $packageName $installerType $installArgs $url $url64
