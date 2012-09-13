try {
  $package = 'OptiPNG'
  $unzipPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $url = 'http://prdownloads.sourceforge.net/optipng/optipng-0.7.1-win32.zip?download'
  Install-ChocolateyZipPackage $package $url $unzipPath

  Install-ChocolateyPath $unzipPath

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
