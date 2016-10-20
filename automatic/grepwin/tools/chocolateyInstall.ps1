$packageName = 'grepwin'
$installerType = 'msi'
$installArgs = '/quiet'
$url = 'https://sourceforge.net/projects/grepwin/files/{{PackageVersion}}/grepWin-{{PackageVersion}}.msi/download'
$url64 = 'https://sourceforge.net/projects/grepwin/files/{{PackageVersion}}/grepWin-{{PackageVersion}}-x64.msi/download'

Install-ChocolateyPackage $packageName $installerType $installArgs $url $url64
