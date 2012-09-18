try {
  $package = 'jscoverage'

  ### Env var to define bin root until we implement configuration ###
  $binRoot = if ($env:chocolatey_bin_root)
    { Join-Path $Env:SystemDrive $Env:chocolatey_bin_root }
  else { $Env:SystemDrive }

  $params = @{
    packageName = $package;
    url = 'http://siliconforks.com/jscoverage/download/jscoverage-0.5.1-windows.zip';
    unzipLocation = (Join-Path $binRoot $package)
    specificFolder = 'jscoverage-0.5.1';
  }

  Install-ChocolateyZipPackage @params

  Write-Host "Adding `'$($params.unzipLocation)`' to the path and the current shell path"
  Install-ChocolateyPath $params.unzipLocation
  $env:Path += ";$($params.unzipLocation)"

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
