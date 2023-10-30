Write-Host 'This will take forever to install. Go outside or something...come back in about an hour or so. For serious yo...'

$url = 'https://download.microsoft.com/download/F/3/1/F31EF055-3C46-4E35-AB7B-3261A303A3B6/AspNetMVC3ToolsUpdateSetup.exe'
$checksumType = 'sha256'
$checksum = '94639EC5B464D47C16953A8CAF53AD00FB48918B15E4AF578E8118CE626BE731'
Install-ChocolateyPackage 'aspnetmvc' 'exe' '/q' $url -ChecksumType $checksumType -Checksum $checksum
#/q but it takes forever....

