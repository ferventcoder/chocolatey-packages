try{
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

  #Changing compat mode to avoid dialog stating that installer must run as a non admin user
  $env:__COMPAT_LAYER="WINXPSP3"
  Install-ChocolateyPackage 'spotify' 'exe' '/SILENT' 'https://download.spotify.com/SpotifySetup.exe'
  $env:__COMPAT_LAYER=$null

  $installerFile = Join-Path $scriptDir 'install.au3'
  write-host "Finishing spotify install with AutoIt3 using `'$installerFile`'"
  $installArgs = "/c autoit3 `"$installerFile`""
  Start-Process "cmd" -ArgumentList "$installArgs" -Wait

  Write-ChocolateySuccess 'spotify'
} catch {
  Write-ChocolateyFailure 'spotify' "$($_.Exception.Message)"
  throw
}
finally {
  $env:__COMPAT_LAYER=$null
}
