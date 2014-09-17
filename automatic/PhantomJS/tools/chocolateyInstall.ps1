try {
  $package = '{{PackageName}}'
  $version = '{{PackageVersion}}'

  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  if (!(Get-Command Get-BinRoot -errorAction SilentlyContinue))
  {
    Import-Module "$($installDir)\Get-BinRoot.ps1"
  }


  # Get $binRoot until we implement YAML configuration
  $binRoot = Get-BinRoot

  $installDir = Join-Path $binRoot $package
  Write-Host "Adding `'$installDir`' to the path and the current shell path"
  Install-ChocolateyPath "$installDir"
  $env:Path = "$($env:Path);$installDir"
  $zipUrl = '{{DownloadUrl}}'

  Install-ChocolateyZipPackage $package "$zipUrl" "$installDir"

  Copy-Item "$($installDir)\phantomjs-$version-windows\*" "$installDir" -Force -Recurse

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}

