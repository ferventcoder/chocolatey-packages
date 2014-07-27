$packageName = 'win2003-mklink'
$url = 'http://schinagl.priv.at/nt/hardlinkshellext/driver/symlink-1.06-x86.cab'
$url64 = 'http://schinagl.priv.at/nt/hardlinkshellext/driver/symlink-1.06-x64.zip'

try{
  $thisDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  $unzipLocation = Join-Path $thisDir "symlinks"
  Install-ChocolateyZipPackage $packageName $url $unzipLocation -url64bit $url64
  
  $chocoPath = $env:ChocolateyInstall
  $chocoPath = Join-Path $chocoPath 'bin'
  $packageBatchFileName = Join-Path $chocoPath "mklink.bat"  
  $path = Join-Path $thisDir 'symlinks\mklink.cmd'
  Write-Host "Adding $packageBatchFileName and pointing to $path"
"@echo off
""$path"" %*" | Out-File $packageBatchFileName -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename `$0).bat `$*""
exit `$?" | Out-File $packageBatchFileName.Replace(".bat","") -encoding ASCII

  write-host "$packageName is now ready. You can type 'mklink' from any command line at any path."

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
