$packageName = 'grepwin'
$installerType = 'msi'
$installArgs = '/quiet'
$url = 'http://sourceforge.net/projects/grepwin/files/{{PackageVersion}}/grepWin-{{PackageVersion}}.msi/download'
$url64 = '{{DownloadUrlx64}}'

Install-ChocolateyPackage $packageName $installerType $installArgs $url $url64
