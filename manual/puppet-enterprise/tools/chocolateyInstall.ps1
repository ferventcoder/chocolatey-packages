$packageName = 'puppet-enterprise'
$installerType = 'msi'
$url = 'http://pm.puppetlabs.com/puppet-enterprise/2.8.1/puppet-enterprise-2.8.1.msi'
$silentArgs = '/quiet'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"  -validExitCodes $validExitCodes
