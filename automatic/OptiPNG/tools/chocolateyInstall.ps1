try {
  $package = 'OptiPNG'
  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

  $zipUrl = 'https://sourceforge.net/projects/optipng/files/OptiPNG/optipng-{{PackageVersion}}/optipng-{{PackageVersion}}-win32.zip/download'

  Install-ChocolateyZipPackage $package "$zipUrl" "$installDir"

  Move-Item -Path "$($installDir)\optipng-{{PackageVersion}}-win32\*" -Destination "$installDir" -Force
  Remove-Item "$($installDir)\optipng-{{PackageVersion}}-win32"

} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}

