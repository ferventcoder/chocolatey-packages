$package = 'Compass'

try {
  gem install compass -v {{PackageVersion}}

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
