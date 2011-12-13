try {
  Install-ChocolateyPackage 'spotify' 'exe' '/S' 'http://download.spotify.com/Spotify%20Installer.exe'
} catch {
  Write-Host 'Spotify installer is reporting error, even though it may have installed correctly. Checking for existence...'
  #------this likes to claim issues even though it installs correctly ----------------
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit -and $progFiles -notmatch 'x86') {$progFiles = "$progFiles (x86)"}

  $spotifyExe = Join-Path $progFiles "Spotify\spotify.exe"

  If (test-path $spotifyExe) {
    Write-ChocolateySuccess 'spotify'
    $errorLog = "$($env:TEMP)\chocolatey\spotify\failure.log"
    if ([System.IO.File]::Exists($errorLog)) {[System.IO.File]::Move($errorLog,(Join-Path ($errorLog) '.old'))}
  } else {
    Write-ChocolateyFailure 'spotify' "$($_.Exception.Message)"
    throw 
  }
}