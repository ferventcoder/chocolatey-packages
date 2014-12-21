# {\{DownloadUrlx64}\} actually contains the URL to FileZilla 32-bit.

$packageId = '{{packageName}}'
$installerType = 'exe'
$unattendedArgs = '/S'
$url = '{{DownloadUrlx64}}'

Install-ChocolateyPackage $packageId $installerType $unattendedArgs $url
