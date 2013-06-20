$packageName = 'TCPOptimizer'
$url = 'http://www.speedguide.net/files/TCPOptimizer.zip'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"