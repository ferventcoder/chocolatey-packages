$packageName = 'npm'
$packageVersion = '1.4.9'
$installerType = 'zip'
$url = 'https://nodejs.org/dist/npm/npm-1.4.9.zip'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

