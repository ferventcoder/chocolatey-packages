$ErrorActionPreference = 'Stop'

$packageName  = 'ShareByLink'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'ShareByLink*'
  fileType      = 'exe'
  silentArgs    = "/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS /NOICONS"
  validExitCodes= @(0,3010)
  url           = 'https://www.sharebylink.com/uploads/5/7/1/5/57158773/sharebylink-setup-win-0-4-1.exe'
  checksum      = '3CBE530CFFC781884E682BCB2EA58EBF8AA2FD51719B2C98A6E396C03A221C07'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs 
