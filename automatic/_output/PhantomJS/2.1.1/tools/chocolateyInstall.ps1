$package = 'PhantomJS'
$version = '2.1.1'
$zipUrl = 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip'
$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage $package "$zipUrl" "$installDir"
