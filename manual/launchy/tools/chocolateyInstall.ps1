$ErrorActionPreference  = 'Stop';
$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName            = 'launchy'
$fileType               = 'exe'
$url                    = 'http://www.launchy.net/downloads/win/LaunchySetup2.6B2.exe'
$softwareName           = 'Launchy*'
$checksum               = '49E6E7F0FDD9BD16E30D827AC421BD9AFD5DD281577A9B08E8A0C3F91BAD62A1'
$checksumType           = 'sha256'
$silentArgs             = '/VERYSILENT /NORESTART'
$validExitCodes         = @(0, 3010, 1605, 1614, 1641)

    $packageArgs = @{
      packageName       = $env:ChocolateyPackageName
      fileType          = $fileType
      url               = $url
      checksum          = $checksum
      checksumType      = $checksumType
      silentArgs        = $silentArgs
      validExitCodes    = $validExitCodes  
    }

Install-ChocolateyPackage @packageArgs
