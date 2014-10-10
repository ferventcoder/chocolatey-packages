$package = 'Yeoman'

try {
  npm install -g yo
  npm update -g yo

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}

