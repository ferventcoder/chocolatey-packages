$packageName = 'CloudBerryExplorer.S3'
$installerType = 'exe'
$url = 'http://www.cloudberrylab.com/download/CloudBerryExplorerSetup_v3.7.0.31.exe'
$url64 = $url
$silentArgs = '/S'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

