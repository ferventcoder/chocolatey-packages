$packageName = 'puppet'
$fileType = 'MSI'
$silentArgs = '/qn'
$url = 'http://downloads.puppetlabs.com/windows/puppet-{{PackageVersion}}.msi'
$url64 = 'http://downloads.puppetlabs.com/windows/puppet-{{PackageVersion}}-x64.msi'

Install-ChocolateyPackage $packageName $fileType $silentArgs $url $url64 -validExitCodes @(0)
