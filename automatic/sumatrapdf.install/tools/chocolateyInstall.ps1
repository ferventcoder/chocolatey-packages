$packageName = 'sumatrapdf.install'
$installerType = 'exe'
$silentArgs = '/S'
$version = '{{PackageVersion}}'
$url = "https://kjkpub.s3.amazonaws.com/sumatrapdf/rel/SumatraPDF-$version-install.exe"
$url64 = "https://kjkpub.s3.amazonaws.com/sumatrapdf/rel/SumatraPDF-$version-64-install.exe"
Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 -validExitCodes @(0)
