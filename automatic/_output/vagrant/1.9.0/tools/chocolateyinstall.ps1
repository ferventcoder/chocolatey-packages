$packageName = 'vagrant'
$url = 'https://releases.hashicorp.com/vagrant/1.9.0/vagrant_1.9.0.msi'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = $url
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
