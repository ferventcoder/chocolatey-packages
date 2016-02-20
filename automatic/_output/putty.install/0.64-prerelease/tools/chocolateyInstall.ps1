$packageName = 'putty.install'
$fileType = 'exe'
$silentArgs = '/VERYSILENT'
$url = 'http://tartarus.org/~simon/putty-prerel-snapshots/x86/putty-installer.exe'
Install-ChocolateyPackage $packageName $fileType $silentArgs $url
