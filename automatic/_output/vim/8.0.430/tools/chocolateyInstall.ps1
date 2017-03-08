try {
  $packageName = 'vim'
  $fileType = 'exe'
  $args = '/S'
  $version = '8.0.430'
  $versionDash = $version -replace '\.', '-'

  $url = "https://sourceforge.net/projects/cream/files/Vim/${version}/gvim-${versionDash}.exe/download"

  Install-ChocolateyPackage $packageName $fileType $args $url

  # Get installation directory from registry

  $regPathWow6432 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Vim'
  $regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Vim'

  if (Test-Path $regPath) {
    $regPathFound = $regPath
  }

  if (Test-Path $regPathWow6432) {
    $regPathFound = $regPathWow6432
  }

  if ($regPathFound) {
    # Add the installation directory to PATH
    $installDir = Split-Path -Parent (
      Get-ItemProperty $regPathFound 'UninstallString'
    ).UninstallString

    Write-Host 'Adding the vim installation directory to PATH …'
    Install-ChocolateyPath $installDir 'Machine'
    $env:Path = "$($env:Path);$installDir"
  }


} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
