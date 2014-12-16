$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Import-Module (Join-Path $PSScriptRoot 'functions.ps1')

$packageName = 'dropbox'
$version = '3.0.3'

$filePath = "$env:TEMP\chocolatey\$packageName"
$fileFullPath = "$filePath\${packageName}Install.exe"
$url = 'https://dl-web.dropbox.com/u/17/Dropbox 3.0.3.exe'

$fileType = 'exe'
$silentArgs = '/S'

# Variables for the AutoHotkey-script
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$ahkFile = "$scriptPath\dropbox.ahk"

try {

  $installedVersion = (getDropboxRegProps).DisplayVersion

  if ($installedVersion -eq $version) {
    Write-Host "Dropbox $version is already installed."
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

  Write-ChocolateySuccess $packageName

} catch {

  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}

