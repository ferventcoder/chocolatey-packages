$packageId = 'ruby'
$name = 'Ruby'
$installerType = 'exe'
$url = 'https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3.exe'
$checksum = '0447f419345bcad7e34dbca8d42b09d0'
$url64 = 'https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3-x64.exe'
$checksum64 = 'b2688631f3eac70dc45a1735ba8ef748'
$silentArgs = "/verysilent"

Install-ChocolateyPackage $name $installerType $silentArgs $url