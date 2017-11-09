﻿$packageArgs = @{
  packageName    = 'puppet-agent'
  fileType       = 'MSI'
  url            = 'https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-{{PackageVersion}}-x86.msi'
  url64bit       = 'https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-{{PackageVersion}}-x64.msi'
  checksum       = 'a1b2c3'
  checksum64     = 'a1b2c3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = "/qn /norestart"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
