Import-Module (Join-Path $PSScriptRoot 'Helpers.psm1')

$packagePath = Join-Path -Resolve $(Split-Path -parent $MyInvocation.MyCommand.Definition) ..
$packageName = 'Dropbox'
$version = '14.4.19'
$url = 'https://clientupdates.dropboxstatic.com/client/Dropbox%2014.4.19%20Offline%20Installer.exe'
$checksum = 'A0827474448EF4EC4E65D61E00757F7812DF9E9004B6D944FDEDEDE6D88DEFE7';

Install $packageName $url $checksum

Start-Process "$packagePath\Dropbox.exe"