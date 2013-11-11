try {
  $package = 'PhantomJS'
  $version = '1.9.2'

  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

  # Temporary include function until it is included with Chocolatey
  Import-Module "$($pwd)\Get-BinRoot.ps1"
    
  # Get $binRoot until we implement YAML configuration
  $binRoot = Get-BinRoot

  $installDir = Join-Path $binRoot $package
  Write-Host "Adding `'$installDir`' to the path and the current shell path"
  Install-ChocolateyPath "$installDir"
  $env:Path = "$($env:Path);$installDir"
  $zipUrl = "https://phantomjs.googlecode.com/files/phantomjs-$version-windows.zip"

  Install-ChocolateyZipPackage $package "$zipUrl" "$installDir"

  Copy-Item "$($installDir)\phantomjs-$version-windows\*" "$installDir" -Force -Recurse

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
