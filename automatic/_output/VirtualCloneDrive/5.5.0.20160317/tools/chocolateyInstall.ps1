$packageId = 'VirtualCloneDrive'
$fileType = 'exe'
$fileArgs = '/S /noreboot'
$url = 'https://www.elby.ch/download/SetupVCD.exe'

$addCertificate = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\addCertificate.ps1"
Start-ChocolateyProcessAsAdmin "& `'$addCertificate`'"
Install-ChocolateyPackage $packageId $fileType $fileArgs $url
