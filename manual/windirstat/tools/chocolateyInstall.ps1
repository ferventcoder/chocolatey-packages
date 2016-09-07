$packageName = 'windirstat'
$fileType = 'exe'
#$url = 'https://prdownloads.sourceforge.net/windirstat/windirstat1_1_2_setup.exe'
$url = 'http://download01.windirstat.info/wds_current_setup.exe'
#$url = 'https://sourceforge.net/projects/windirstat/files/windirstat/1.1.2%20installer%20re-release%20%28more%20languages%21%29/windirstat1_1_2_setup.exe/download'
$silentArgs = '/S'
$checksum = '6fa92dd2ca691c11dfbfc0a239e34369897a7fab'


Install-ChocolateyPackage $packageName $fileType "$silentArgs" "$url" -checksum $checksum -checksumType 'sha1'

