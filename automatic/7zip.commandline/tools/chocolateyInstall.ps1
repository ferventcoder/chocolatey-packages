$packageId = '7zip.commandline'
$url = '{{DownloadUrl}}'
$PSScriptRoot = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage $packageId $url $PSScriptRoot
