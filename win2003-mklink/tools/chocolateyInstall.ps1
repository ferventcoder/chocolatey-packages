try{
  $chocoPath = $env:ChocolateyInstall
  $chocoPath = Join-Path $chocoPath 'bin'
  $packageBatchFileName = Join-Path $chocoPath "mklink.bat"

  $thisDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  $path = Join-Path $thisDir 'symlinks\mklink.cmd'
  Write-Host "Adding $packageBatchFileName and pointing to $path"
"@echo off
""$path"" %*" | Out-File $packageBatchFileName -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename `$0).bat `$*""
exit `$?" | Out-File $packageBatchFileName.Replace(".bat","") -encoding ASCII

  write-host "win2003-mklink is now ready. You can type 'mklink' from any command line at any path."

  Write-ChocolateySuccess 'win2003-mklink'
} catch {
  Write-ChocolateyFailure 'win2003-mklink' "$($_.Exception.Message)"
  throw
}
