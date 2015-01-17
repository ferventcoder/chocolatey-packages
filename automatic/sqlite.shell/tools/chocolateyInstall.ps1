$packageName = 'sqlite.shell'
$url = '{{DownloadUrl}}'
$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

Install-ChocolateyZipPackage $packageName $url $PSScriptRoot
