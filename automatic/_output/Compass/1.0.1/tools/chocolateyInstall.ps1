$package = 'Compass'

try {
  gem install compass -v 1.0.1

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
