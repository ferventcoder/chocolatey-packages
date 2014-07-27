try {

  $dirSelected = Read-Host "Please tell me the directory where you want to clone dropkick. Press enter to use .\dropkick"
  
  if ($dirSelected -eq '') {$dirSelected = '.\dropkick'}
  
  git clone git://github.com/chucknorris/dropkick.git $dirSelected
  
  Start-Sleep 6
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 8
	throw 
}