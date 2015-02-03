# {\{DownloadUrlx64}\} actually contains the URL to FileZilla 32-bit.

$packageId = 'filezilla'
$installerType = 'exe'
$unattendedArgs = '/S'
$url = 'http://sourceforge.net/projects/filezilla/files/FileZilla_Client/3.10.1.1/FileZilla_3.10.1.1_win32-setup.exe/download'

Install-ChocolateyPackage $packageId $installerType $unattendedArgs $url
