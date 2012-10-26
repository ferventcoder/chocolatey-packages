$packageName = 'virtualbox'

Install-ChocolateyPackage $packageName 'exe' '-s' '{{DownloadUrl}}'

try {
 # create the temp dir
 #$tempDir = #some folder under temp\chocolatey
 # name file fullpath
 #$fileFullPath = Join-Path $tempDir 'virtualbox.exe'
 # get the file
 # Get-ChocolateyWebFile $packageName $fileFullPath '{{DownloadUrl}}'
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