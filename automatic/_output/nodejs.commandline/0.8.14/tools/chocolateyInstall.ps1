try { 
  $nodePath = Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'node.exe'
  Get-ChocolateyWebFile 'nodejs' "$nodePath" 'http://nodejs.org/dist/v0.8.14/node.exe'
  
  Write-ChocolateySuccess 'nodejs'
} catch {
  Write-ChocolateyFailure 'nodejs' "$($_.Exception.Message)"
  throw 
}