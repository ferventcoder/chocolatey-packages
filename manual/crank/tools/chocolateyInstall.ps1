try {
  $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $crankExe = Join-Path $toolsDir 'crank.exe'
  Get-ChocolateyWebFile 'crank' $crankExe 'https://github.com/downloads/SignalR/crank/crank.exe'

  Write-ChocolateySuccess 'crank'
} catch {
  Write-ChocolateyFailure 'crank' "$($_.Exception.Message)"
  throw
}
