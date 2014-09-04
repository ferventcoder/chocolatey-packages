Install-ChocolateyPackage 'puppet' 'MSI' '/qn' 'http://downloads.puppetlabs.com/windows/puppet-{{PackageVersion}}.msi' 'http://downloads.puppetlabs.com/windows/puppet-{{PackageVersion}}-x64.msi' -validExitCodes @(0)

