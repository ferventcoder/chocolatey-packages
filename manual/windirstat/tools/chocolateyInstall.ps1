$packageName = 'windirstat'
$fileType = 'exe'
$url = 'http://prdownloads.sourceforge.net/windirstat/windirstat1_1_2_setup.exe'
$silentArgs = '/S'

Install-ChocolateyPackage $packageName $fileType "$silentArgs" "$url"
