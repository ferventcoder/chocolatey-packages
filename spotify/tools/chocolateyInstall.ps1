function Reset-ChocoEnvironment 
{
  #rename-item function:Start-ChocolateyProcessAsAdmin Start-ChocolateyProcessAsAdmin-SpotifyOverride
  #rename-item function:Start-ChocolateyProcessAsAdmin-Hold Start-ChocolateyProcessAsAdmin
  if (Get-Module spotify-chocolatey) {Remove-Module spotify-chocolatey}
}

try{
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $spotifyModule = Join-Path $scriptDir 'functions\spotify-chocolatey.psm1'
  if (Get-Module spotify-chocolatey) {Remove-Module spotify-chocolatey}
  Import-Module $spotifymodule
  
  #Write-Host "Renaming `'Start-ChocolateyProcessAsAdmin`' to `'Start-ChocolateyProcessAsAdmin-Hold`'"
  #rename-item function:Start-ChocolateyProcessAsAdmin Start-ChocolateyProcessAsAdmin-Hold
  #rename-item function:Start-ChocolateyProcessAsAdmin-Override Start-ChocolateyProcessAsAdmin
  
  Install-ChocolateyPackage-Spotify 'spotify' 'exe' '/SILENT' 'http://download.spotify.com/SpotifySetup.exe'

  $installerFile = Join-Path $scriptDir 'install.au3'
  write-host "Finishing spotify install with AutoIt3 using `'$installerFile`'"
  $installArgs = "/c autoit3 `"$installerFile`""
  #Start-ChocolateyProcessAsAdmin "$installArgs" 'cmd.exe'
  Start-Process "cmd" -ArgumentList "$installArgs" -Wait
  
  Reset-ChocoEnvironment

  Write-ChocolateySuccess 'spotify'
} catch {
  Write-ChocolateyFailure 'spotify' "$($_.Exception.Message)"
  Reset-ChocoEnvironment
  
  throw 
}