$packageName = 'StExBar'
$url = 'https://sourceforge.net/projects/stefanstools/files/StExBar/StExBar-1.9.0.msi/download'
$url64 = 'https://sourceforge.net/projects/stefanstools/files/StExBar/StExBar64-1.9.0.msi/download'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

