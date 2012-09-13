$package = 'Compass'

try {
  gem install compass -v 0.2.12

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
