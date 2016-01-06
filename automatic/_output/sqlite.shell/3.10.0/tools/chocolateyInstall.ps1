$packageName = 'sqlite.shell'
$url = 'https://www.sqlite.org/2016/sqlite-shell-win32-x86-3100000.zip'
$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

Install-ChocolateyZipPackage $packageName $url $PSScriptRoot
