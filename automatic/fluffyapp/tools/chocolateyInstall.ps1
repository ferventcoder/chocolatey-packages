try {
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $AU3File = Join-Path $scriptDir 'fluffyapp.au3'
  $installerDir = Join-Path $scriptDir 'installer'

  Install-ChocolateyZipPackage 'fluffyapp' '{{DownloadUrl}}' "$installerDir"

  $installerExe = Join-Path $installerDir 'FluffyAppInstaller.exe'

  write-host "Installing `'$installerExe`' with AutoIt3 using `'$AU3File`'"
  $installArgs = "/c autoit3 `"$AU3File`" `"$installerExe`""
  Start-ChocolateyProcessAsAdmin "$installArgs" 'cmd.exe'

  #delete install dir
  Remove-Item $installerDir -Force -Recurse

  Write-ChocolateySuccess 'fluffyapp'
} catch {
  Write-ChocolateyFailure 'fluffyapp' "$($_.Exception.Message)"
  throw
}
