try { 
  $toolsDir ="$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Start-ChocolateyProcessAsAdmin "& $($toolsDir)\installmysql.ps1"

  Write-ChocolateySuccess 'mysql'
} catch {
  Write-ChocolateyFailure 'mysql' "$($_.Exception.Message)"
  throw 
}