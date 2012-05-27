try { 
  $nodePath = Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'node.exe'
  Get-ChocolateyWebFile 'nodejs' "$nodePath" '{{DownloadUrl}}'
  
  Write-ChocolateySuccess 'nodejs'
} catch {
  Write-ChocolateyFailure 'nodejs' "$($_.Exception.Message)"
  throw 
}