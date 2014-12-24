$packageId = '{{PackageName}}'
$fileType = 'exe'
$fileArgs = '/S'

# If you see \{\{DownloadUrlx64\}\} (without backslashes) in the source code,
# it’s intentional.
$url = '{{DownloadUrlx64}}'

Install-ChocolateyPackage $packageId $fileType $fileArgs $url -validExitCodes @(0)
