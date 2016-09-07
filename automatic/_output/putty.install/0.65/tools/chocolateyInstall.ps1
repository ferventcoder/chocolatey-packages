$packageName = 'putty.install'
$fileType = 'exe'
$silentArgs = '/VERYSILENT'
$url = 'http://the.earth.li/~sgtatham/putty/0.65/x86/putty-0.65-installer.exe'
Install-ChocolateyPackage $packageName $fileType $silentArgs $url
