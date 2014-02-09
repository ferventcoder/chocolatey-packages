try {

  $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  Install-ChocolateyZipPackage 'paint.net' '{{DownloadUrl}}' $toolsDir

  $paintFileFullPath = get-childitem $toolsDir -recurse -include *.exe | select -First 1
  Install-ChocolateyInstallPackage 'paint.net' 'exe' '/auto DESKTOPSHORTCUT=0' "$paintFileFullPath"

  Remove-Item "$paintFileFullPath"

  Write-ChocolateySuccess 'paint.net'
} catch {
  Write-ChocolateyFailure 'paint.net' "$($_.Exception.Message)"
  throw 
}