try { 
  $toolsDir ="$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Start-ChocolateyProcessAsAdmin "& $($toolsDir)\installmemcached.ps1"

  Write-ChocolateySuccess 'memcached'
} catch {
  Write-ChocolateyFailure 'memcached' "$($_.Exception.Message)"
  throw 
}