$package = 'Yeoman'

try {
  npm install -g yeoman

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
