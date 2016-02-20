$packageName = 'vagrant'
$url = 'https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4.msi'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = $url
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
