#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://download.skype.com/3694814915aaa38100bfa0933f948e65/partner/59/SkypeSetup.exe'
#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' '{{DownloadUrl}}'
#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://download.skype.com/SkypeSetupFull.exe'


function isInstalled() {
  return Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match 'Skype\u2122 [\d\.]+$'}
}

function downloadInstaller {
    param(
      [string] $packageName,
      [alias("installerType")][string] $fileType = 'exe',
      [string] $url,
      [alias("url64")][string] $url64bit = '',
      [string] $checksum = '',
      [string] $checksumType = '',
      [string] $checksum64 = '',
      [string] $checksumType64 = '',
      [hashtable] $options = @{Headers=@{}}
    )
    $chocTempDir = Join-Path $env:TEMP 'chocolatey'
    $tempDir = Join-Path $chocTempDir "$packageName"
    if ($env:packageVersion -ne $null) {$tempDir = Join-Path $tempDir "$env:packageVersion"; }
    if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
    $file = Join-Path $tempDir "$($packageName)Install.$fileType"
    $filePath = Get-ChocolateyWebFile $packageName $file $url $url64bit -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64 -options $options -getOriginalFileName

    $filePath = if ($myval -ne $null) { $filePath } else { $file }
    return $filePath
}

function uninstallExisting($appInstalled, $silentArgs) {
    # If Skype (in any version) is already installed on the computer, remove it first, otherwise the
    # installation of Skype will fail with an error.
    $msiArgs = $('/x' + $appInstalled.IdentifyingNumber + ' ' + $silentArgs)
    Write-Host "Uninstalling previous version of Skype, otherwise installing the new version won’t work."

    Start-ChocolateyProcessAsAdmin $msiArgs 'msiexec'

    # This loop checks every 5 seconds if Skype is already uninstalled.
    # Then it proceeds with the download and installation of the Skype
    # version specified in the package.
    do {
      Start-Sleep -Seconds 5
      $i += 1

      # Break if too much time passed
      if ($i -gt 12) {
        Write-Error 'Could not uninstall the previous version of Skype.'
        break
      }

    } until (-not (isInstalled))
}

$packageName = 'skype'
$fileType    = 'msi'

# http://community.skype.com/t5/Windows-archive/Unattended-install/td-p/184628s
$updatesilentArgs = '/qn /norestart STARTSKYPE=FALSE TRANSFORMS=:RemoveDesktopShortcut.mst'
$silentArgs       = "$updatesilentArgs TRANSFORMS=:RemoveStartup.mst"

$url = '{{DownloadUrl}}'


$appInstalled = isInstalled
$filePath     = downloadInstaller $packageName $fileType $url

if ($appInstalled) {
    uninstallExisting $appInstalled $updatesilentArgs

    $silentArgs = $updatesilentArgs
}

Install-ChocolateyInstallPackage $packageName $fileType $silentArgs $filePath
