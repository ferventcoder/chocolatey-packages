try {

  $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  Install-ChocolateyZipPackage 'paint.net' 'http://www.dotpdn.com/files/Paint.NET..0.0.20140103.Install.zip' $toolsDir

  $paintFileFullPath = get-childitem $toolsDir -recurse -include *.exe | select -First 1
  Install-ChocolateyInstallPackage 'paint.net' 'exe' '/auto DESKTOPSHORTCUT=0' "$paintFileFullPath"

  Remove-Item "$paintFileFullPath"

  Write-ChocolateySuccess 'paint.net'
} catch {
  Write-ChocolateyFailure 'paint.net' "$($_.Exception.Message)"
  throw 
}