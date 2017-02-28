$ErrorActionPreference = 'SilentlyContinue';
$packageName = 'puppet'
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$installDir = Join-Path "$toolsDir" 'puppet'

# Remove the BATs from choco bin
$binFilesDir = Join-Path "$installDir" 'SourceDir\Puppet Labs\Puppet\bin'
Remove-BinFile -name 'puppet' -path "$binFilesDir\puppet.bat"
Remove-BinFile -name 'facter' -path "$binFilesDir\facter.bat"
Remove-BinFile -name 'hiera' -path "$binFilesDir\hiera.bat"
Remove-BinFile -name 'mco' -path "$binFilesDir\mco.bat"

Write-Warning "This package does not clean up ProgramData\PuppetLabs. You will need to do that manually."