try {

  $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  Install-ChocolateyZipPackage 'paint.net' 'http://www.dotpdn.com/files/Paint.NET.3.5.8.Install.zip' $toolsDir

  $paintFileFullPath = Join-Path $toolsDir 'Paint.NET.3.5.8.Install.exe'
  Install-ChocolateyInstallPackage 'paint.net' 'exe' '/auto DESKTOPSHORTCUT=0' $paintFileFullPath

  Write-ChocolateySuccess 'paint.net'
} catch {
  Write-ChocolateyFailure 'paint.net' "$($_.Exception.Message)"
  throw 
}