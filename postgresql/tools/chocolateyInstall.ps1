try { 
  $toolsDir ="$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Start-ChocolateyProcessAsAdmin "& $($toolsDir)\installpostgre.ps1"

  Write-ChocolateySuccess 'postgresql'
} catch {
  Write-ChocolateyFailure 'postgresql' "$($_.Exception.Message)"
  throw 
}