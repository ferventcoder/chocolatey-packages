$packageName = 'StExBar'
$installerType = 'msi'
$silentArgs = '/quiet /norestart'
$url = 'http://sourceforge.net/projects/stefanstools/files/StExBar/StExBar-{{PackageVersion}}.msi/download'
$url64 = 'http://sourceforge.net/projects/stefanstools/files/StExBar/StExBar64-{{PackageVersion}}.msi/download'

Install-ChocolateyPackage $packageName $installerType "$silentArgs" "$url" "$url64"
