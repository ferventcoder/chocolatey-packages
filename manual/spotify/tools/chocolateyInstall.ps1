$script           = $MyInvocation.MyCommand.Definition
$packageArgs      = @{
  packageName     = 'Spotify'
  fileType        = 'exe'
  fileFullPath    = Join-Path (Split-Path -Parent $script) 'SpotifyFullSetup.exe'
  url             = 'http://download.spotify.com/SpotifyFullSetup.exe'
  softwareName    = 'Spotify*'
  checksum        = 'DC1770943FCFADC07DF5E399BA89D071E1E82311284860573C08E05D31BBF965'
  checksumType    = 'sha256'
  silentArgs      = '/silent'
  validExitCodes  = @(0, 3010, 1641)
}

# Get the Spotify installer
Get-ChocolateyWebFile @packageArgs 

# Start the installer as a scheduled task to get around the 'can't install as admin' issue
$action = New-ScheduledTaskAction -Execute $packageArgs['fileFullPath'] -Argument $packageArgs['silentArgs']
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date)
Register-ScheduledTask -TaskName $packageArgs['packageName'] -Action $action -Trigger $trigger
Start-ScheduledTask -TaskName $packageArgs['packageName']
Start-Sleep -s 1
Unregister-ScheduledTask -TaskName $packageArgs['packageName'] -Confirm:$false

# Wait for Spotify to start, and kill it
$done = $false
do {
  if (Get-Process Spotify -ErrorAction SilentlyContinue) {
    Stop-Process -name Spotify
    $done = $true
  }

  Start-Sleep -s 10
} until ($done)