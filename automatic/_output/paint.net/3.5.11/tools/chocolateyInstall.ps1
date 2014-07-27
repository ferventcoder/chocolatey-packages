try {

  $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  Install-ChocolateyZipPackage 'paint.net' 'http://www.filehippo.com/download/file/56db1707ca58575b34eadf7a2ff0d3b9f6f40041f5a389fbf39d6cbc9152bd63' $toolsDir

  $paintFileFullPath = get-childitem $toolsDir -recurse -include *.exe | select -First 1
  Install-ChocolateyInstallPackage 'paint.net' 'exe' '/auto DESKTOPSHORTCUT=0' "$paintFileFullPath"

  Remove-Item "$paintFileFullPath"

  Write-ChocolateySuccess 'paint.net'
} catch {
  Write-ChocolateyFailure 'paint.net' "$($_.Exception.Message)"
  throw 
}