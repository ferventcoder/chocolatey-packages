try {
  $package = 'PhantomJS'
  $unzipPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $url = 'http://phantomjs.googlecode.com/files/phantomjs-1.6.1-win32-static.zip'
  Install-ChocolateyZipPackage $package $url $unzipPath

  Install-ChocolateyPath $unzipPath

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
