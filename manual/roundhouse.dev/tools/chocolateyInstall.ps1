try { 
  $dirSelected = Read-Host "Please tell me the directory where you want to clone roundhouse. Press enter to use .\roundhouse"
  if ($dirSelected -eq '') {$dirSelected = '.\roundhouse'}

  $cloneSelected = Read-Host "Please tell me the git clone you want to use. Press enter to use git://github.com/chucknorris/roundhouse.git"
  if ($cloneSelected -eq '') {$cloneSelected = 'git://github.com/chucknorris/roundhouse.git'}
  
  git clone $cloneSelected $dirSelected
  
  Write-ChocolateySuccess 'roundhouse.dev'
} catch {
  Write-ChocolateyFailure 'roundhouse.dev' "$($_.Exception.Message)"
  throw 
}