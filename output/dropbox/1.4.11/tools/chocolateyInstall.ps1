#Install-ChocolateyPackage 'dropbox' 'exe' '/S' 'https://www.dropbox.com/download?plat=win' # -validExitCodes @(0)
try {
  #based on http://wpkg.org/Dropbox
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $installerFile = Join-Path $scriptDir 'dropbox.au3'

  $tempDir = "$env:TEMP\chocolatey\dropbox"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $file = Join-Path $tempDir "dropboxInstall.exe"
  Get-ChocolateyWebFile 'dropbox' "$file" 'https://www.dropbox.com/download?plat=win'
  
  write-host "Installing `'$file`' with AutoIt3 using `'$installerFile`'"
  $installArgs = "/c autoit3 `"$installerFile`" `"$file`""
  Start-ChocolateyProcessAsAdmin "$installArgs" 'cmd.exe'
  #Start-Process "autoit3" -ArgumentList "$installerFile `"$file`"" -Wait

  Write-ChocolateySuccess 'dropbox'
} catch {
  Write-ChocolateyFailure 'dropbox' "$($_.Exception.Message)"
  throw 
}