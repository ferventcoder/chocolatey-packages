$packageName = 'puppet'
$fileType = 'MSI'
$silentArgs = '/qn'
$url = 'http://downloads.puppetlabs.com/windows/puppet-3.8.1.msi'
$url64 = 'http://downloads.puppetlabs.com/windows/puppet-3.8.1-x64.msi'

Install-ChocolateyPackage $packageName $fileType $silentArgs $url $url64 -validExitCodes @(0)
