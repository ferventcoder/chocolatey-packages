try {
  Install-ChocolateyPackage 'spotify' 'exe' '/S' 'http://download.spotify.com/Spotify%20Installer.exe'
} catch {
  #------this likes to claim issues even though it installs correctly ----------------
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit) {$progFiles = "$progFiles (x86)"}

  $spotifyExe = Join-Path $progFiles "Spotify\spotify.exe"

  If (test-path $spotifyExe) {
    Write-ChocolateySuccess 'spotify'
  } else {
    Write-ChocolateyFailure 'spotify' "$($_.Exception.Message)"
    throw 
  }
}