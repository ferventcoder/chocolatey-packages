try {
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

  $tempDir = "$env:TEMP\chocolatey\autoit.commandline"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $file = Join-Path $tempDir "autoit.commandlineInstall.exe"
  Get-ChocolateyWebFile 'autoit.commandline' "$file" 'http://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3-sfx.exe'
  
  write-host "Extracting the contents of `'$file`' to `'$scriptDir`'"
  start-sleep 3
  Start-Process "7za" -ArgumentList "x -o`"$scriptDir`" -y `"$file`"" -Wait

  Write-ChocolateySuccess 'autoit.commandline'
} catch {
  Write-ChocolateyFailure 'autoit.commandline' "$($_.Exception.Message)"
  throw 
}