$packageId = 'VirtualCloneDrive'
$fileType = 'exe'
$fileArgs = '/S /noreboot'
$url = '{{DownloadUrl}}'

$addCertificate = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\addCertificate.ps1"
Start-ChocolateyProcessAsAdmin "& `'$addCertificate`'"
Install-ChocolateyPackage $packageId $fileType $fileArgs $url
