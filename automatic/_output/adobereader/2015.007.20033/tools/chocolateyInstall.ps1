$packageName = 'adobereader'
$installerType = 'EXE'
#Command Line Switches for the Bootstrap Web Installer: https://forums.adobe.com/message/3291894#3291894
$silentArgs = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
$url = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1500720033/AcroRdrDC1500720033_MUI.exe'
$validExitCodes = @(0, 3010)
$checksumType = 'sha256'
$checksum = 'dfc4b3c70b7ecaeb40414c9d6591d8952131a5fffa0c0f5964324af7154f8111'

Install-ChocolateyPackage $packageName $installerType $silentArgs $url -validExitCodes $validExitCodes -Checksum $checksum -ChecksumType $checksumType
