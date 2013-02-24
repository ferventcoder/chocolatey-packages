try {
  $sysDrive = $env:SystemDrive
  $gittfsPath = "$sysDrive\tools\gittfs"
  
  Install-ChocolateyZipPackage 'gittfs' 'https://github.com/downloads/git-tfs/git-tfs/GitTfs-0.16.1.zip' $gittfsPath
  Install-ChocolateyPath $gittfsPath

  write-host 'git-tfs has been installed. Call git tfs from the command line to see options. You may need to close and reopen the command shell.'
  Write-ChocolateySuccess 'gittfs'
} catch {
  Write-ChocolateyFailure 'gittfs' $($_.Exception.Message)
  throw 
}