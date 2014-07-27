$packageName = 'virtualbox'

Install-ChocolateyPackage $packageName 'exe' '-s' 'http://download.virtualbox.org/virtualbox/4.2.6/VirtualBox-4.2.6-82870-Win.exe'

try {
 # create the temp dir
 #$tempDir = #some folder under temp\chocolatey
 # name file fullpath
 #$fileFullPath = Join-Path $tempDir 'virtualbox.exe'
 # get the file
 # Get-ChocolateyWebFile $packageName $fileFullPath 'http://download.virtualbox.org/virtualbox/4.2.6/VirtualBox-4.2.6-82870-Win.exe'
 # extract the contents
 #. $fileFullPath -x -p $tempDir
 # find the proper msi
 #$msiFile = $tempDir #find it
 # run it
 #Install-ChocolateyInstallPackage $packageName 'msi' '/quiet /norestart' $msiFile 

  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
  throw 
}