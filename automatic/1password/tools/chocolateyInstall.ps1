$packageId = '1password'
$fileType = 'exe'
$installArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
$url = '{{DownloadUrl}}'

Install-ChocolateyPackage $packageId $fileType $installArgs $url -validExitCodes @(0)
