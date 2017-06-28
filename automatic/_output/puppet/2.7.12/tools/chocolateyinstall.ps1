$packageName = 'puppet'
$url = 'https://downloads.puppetlabs.com/windows/puppet-2.7.12.msi'
$url64 = 'https://downloads.puppetlabs.com/windows/puppet-2.7.12-x64.msi'


$packageArgs = @{
  packageName   = $packageName
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
