try {

  npm install -g typescript
  npm update -g typescript

  # the following is all part of error handling
  Write-ChocolateySuccess 'typescript'
} catch {
  Write-ChocolateyFailure 'typescript' "$($_.Exception.Message)"
  throw
}
