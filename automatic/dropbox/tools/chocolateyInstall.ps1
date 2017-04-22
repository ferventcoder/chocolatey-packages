﻿$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Import-Module (Join-Path $PSScriptRoot 'functions.ps1')

$packageName = 'dropbox'
$version = '{{PackageVersion}}'

$filePath = "$env:TEMP\chocolatey\$packageName"
$fileFullPath = "$filePath\${packageName}Install.exe"
$url = 'https://dl-web.dropbox.com/u/17/Dropbox {{PackageVersion}}.exe'

$fileType = 'exe'
$silentArgs = '/S'

# Variables for the AutoHotkey-script
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$ahkFile = "$scriptPath\dropbox.ahk"

try {

  $installedVersion = (getDropboxRegProps).DisplayVersion

  if ($installedVersion -ge $version) {
    Write-Host "Dropbox $installedVersion is already installed."
  } else {

    # Download and install Dropbox

    if (-not (Test-Path $filePath)) {
      New-Item $filePath -type directory
    }

    Get-ChocolateyWebFile $packageName $fileFullPath $url
    Start-Process 'AutoHotkey' $ahkFile
    Start-Process $fileFullPath $silentArgs
    Wait-Process -Name "dropboxInstall"
    Remove-Item $fileFullPath
  }

} catch {

  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}

