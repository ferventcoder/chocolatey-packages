$package = 'PhantomJS'
$version = '2.0.0'
$zipUrl = 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-windows.zip'
$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage $package "$zipUrl" "$installDir"
