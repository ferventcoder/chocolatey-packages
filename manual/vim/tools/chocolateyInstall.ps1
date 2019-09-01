try {
  $packageName = 'vim'
  $fileType = 'exe'
  $args = '/S'

  $url = "https://ftp.nluug.nl/pub/vim/pc/gvim81.exe"
  Install-ChocolateyPackage $packageName $fileType $args $url

  # Get installation directory from registry
  $regPath = 'HKLM:\SOFTWARE\Vim\Gvim'

  if (Test-Path $regPath) {
    $regPathFound = $regPath
  }

  if ($regPathFound) {
    # Add the installation directory to PATH
    $installDir = Split-Path -Parent (
      Get-ItemProperty $regPathFound 'Path'
    ).Path

    Write-Host 'Adding the vim installation directory to PATH …'

    Write-Host "Installdir : $installDir"

    Install-ChocolateyPath $installDir 'Machine'
    $env:Path = "$($env:Path);$installDir"
  }

} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
