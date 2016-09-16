$ErrorActionPreference = 'Stop'

$packageName = 'lockhunter'
$url32       = 'http://lockhunter.com/exe/lockhuntersetup_3-1-1.exe'
$checksum32  = 'ADEA78761F18BAAF938F9B5A18EE3B07CB6426F8ADFA234F715630741130EE7D'

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'exe'
  url                    = $url32
  silentArgs             = '/SILENT'
  checksum               = $checksum32
  checksumType           = 'sha256'
  validExitCodes         = @(0)
  registryUninstallerKey = $packageName
}

Install-ChocolateyPackage @packageArgs
