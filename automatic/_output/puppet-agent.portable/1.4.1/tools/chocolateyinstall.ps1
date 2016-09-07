$packageName = 'puppet'
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$installDir = Join-Path "$toolsDir" 'puppet'
$fileName = "$($packageName).msi"
$file = Join-Path "$toolsDir" "$fileName"
$url = 'http://downloads.puppetlabs.com/windows/puppet-agent-1.4.1-x86.msi'
$url64 = 'http://downloads.puppetlabs.com/windows/puppet-agent-1.4.1-x64.msi'


Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"

pushd "$toolsDir"
# the trailing backslash is required!
&lessmsi x "$fileName" "$installDir\"
popd

function Create-DirectoryIfNotExists($folderName){
  if (![System.IO.Directory]::Exists($folderName)) { [System.IO.Directory]::CreateDirectory($folderName) | Out-Null }
}


$puppetProgramDataDir = Join-Path "$env:ALLUSERSPROFILE" 'PuppetLabs'
Create-DirectoryIfNotExists $puppetProgramDataDir

# Copy the source files
$progDataFilesDir = Join-Path "$installDir" 'SourceDir\CommonAppData\PuppetLabs'
Copy-Item "$($progDataFilesDir)\*" "$puppetProgramDataDir" -Force -Recurse

# Create the rest of the ProgramData structure if necessary
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'code')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'facter')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'facter\facts.d')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'hiera')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'hiera\etc')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'hiera\var')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'mcollective')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'mcollective\etc')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'mcollective\var')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'puppet')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'puppet\etc')"
Create-DirectoryIfNotExists "$(Join-Path $puppetProgramDataDir 'puppet\var')"


# Add the BATs to choco bin
$binFilesDir = Join-Path "$installDir" 'SourceDir\Puppet Labs\Puppet\bin'
Add-BinFile -name 'puppet' -path "$binFilesDir\puppet.bat"
Add-BinFile -name 'facter' -path "$binFilesDir\facter.bat"
Add-BinFile -name 'hiera' -path "$binFilesDir\hiera.bat"
Add-BinFile -name 'mco' -path "$binFilesDir\mco.bat"