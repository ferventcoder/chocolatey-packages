try { 
  $scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $nodePath = Join-Path $scriptPath 'node.exe'
  Get-ChocolateyWebFile 'nodejs' "$nodePath" 'http://nodejs.org/dist/v0.5.2/node.exe'
 Write-ChocolateySuccess 'nodejs'
} catch {
  Write-ChocolateyFailure 'nodejs' "$($_.Exception.Message)"
  throw 
}