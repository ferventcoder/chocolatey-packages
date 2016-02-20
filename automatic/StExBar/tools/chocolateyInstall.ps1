$packageName = 'StExBar'
$url = 'http://sourceforge.net/projects/stefanstools/files/StExBar/StExBar-{{PackageVersion}}.msi/download'
$url64 = 'http://sourceforge.net/projects/stefanstools/files/StExBar/StExBar64-{{PackageVersion}}.msi/download'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

