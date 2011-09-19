try {
  $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $putty = Join-Path $toolsDir 'putty.exe'
  Get-ChocolateyWebFile 'putty' $putty 'http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe' 
  
  Write-ChocolateySuccess 'putty'
} catch {
  Write-ChocolateyFailure 'putty' "$($_.Exception.Message)"
  throw 
}