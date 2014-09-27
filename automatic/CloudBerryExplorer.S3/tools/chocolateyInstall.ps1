$packageName = 'CloudBerryExplorer.S3'
$installerType = 'exe'
$url = '{{DownloadUrl}}'
$url64 = $url
$silentArgs = '/S'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
