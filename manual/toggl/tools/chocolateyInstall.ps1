$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://toggl.com/api/v8/installer?app=td&platform=windows&channel=stable'
  softwareName   = 'Toggl Desktop'
  checksum       = 'BC911D72BFD0D330628F38D9D7DCEEE9ECFD1E98B7DF45BBCFAC89C8B836D792'
  checksumType   = 'sha256'
  silentArgs     = "/S"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
