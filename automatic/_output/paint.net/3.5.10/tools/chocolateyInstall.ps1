Install-ChocolateyPackage 'paint.net' 'exe' '/auto DESKTOPSHORTCUT=0' 'http://www.filehippo.com/download/file/26d29b32c6b3d1b5075da9ab563e8ba02c0e87a29cfadbf08b5b71d10f0cd920' -validExitCodes @(0)
# try {

  # $toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  # Install-ChocolateyZipPackage 'paint.net' 'http://www.filehippo.com/download/file/26d29b32c6b3d1b5075da9ab563e8ba02c0e87a29cfadbf08b5b71d10f0cd920' $toolsDir

  # $paintFileFullPath = get-childitem $toolsDir -recurse -include *.exe | select -First 1
  # Install-ChocolateyInstallPackage 'paint.net' 'exe' '/auto DESKTOPSHORTCUT=0' "$paintFileFullPath"

  # Remove-Item "$paintFileFullPath"

  # Write-ChocolateySuccess 'paint.net'
# } catch {
  # Write-ChocolateyFailure 'paint.net' "$($_.Exception.Message)"
  # throw 
# }