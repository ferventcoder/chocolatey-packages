$packageName = 'StExBar'
$installerType = 'msi'
$silentArgs = '/quiet /norestart'
$url = 'http://sourceforge.net/projects/stefanstools/files/StExBar/StExBar-1.8.6.msi/download'
$url64 = 'http://sourceforge.net/projects/stefanstools/files/StExBar/StExBar64-1.8.6.msi/download'

Install-ChocolateyPackage $packageName $installerType "$silentArgs" "$url" "$url64"
