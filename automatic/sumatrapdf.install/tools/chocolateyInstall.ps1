$packageName = 'sumatrapdf.install'
$installerType = 'exe'
$silentArgs = '/S'
$version = '{{PackageVersion}}'
$url = "https://www.sumatrapdfreader.org/dl2/SumatraPDF-$version-install.exe"
$url64 = "https://www.sumatrapdfreader.org/dl2/SumatraPDF-$version-64-install.exe"
Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 -validExitCodes @(0)
