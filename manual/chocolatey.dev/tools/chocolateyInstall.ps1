try {
  $dirSelected = Read-Host "Please tell me the directory where you want to clone chocolatey. Press enter to use .\chocolatey"
  if ($dirSelected -eq '') {$dirSelected = '.\chocolatey'}

  $cloneSelected = Read-Host "Please tell me the git clone you want to use. Press enter to use git://github.com/chocolatey/chocolatey.git"
  if ($cloneSelected -eq '') {$cloneSelected = 'git://github.com/chocolatey/chocolatey.git'}

  git clone $cloneSelected $dirSelected

  Write-ChocolateySuccess 'chocolatey.dev'
} catch {
  Write-ChocolateyFailure 'chocolatey.dev' "$($_.Exception.Message)"
  throw
}
