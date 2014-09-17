$package = 'Compass'

try {
  gem install compass -v 0.12.2

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}

