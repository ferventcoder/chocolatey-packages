try{
  $toolsdir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  $contentSettingsFile =  Join-Path   $toolsdir 'console.xml'
  $binSettingsFile = ($toolsdir | Join-Path -ChildPath 'console2' | Join-Path -ChildPath 'console.xml')

  if(!(test-path $binSettingsFile)) {
      Write-Host "Creating default settings file from $contentSettingsFile"
      copy-item $contentSettingsFile $binSettingsFile
  }

  Write-ChocolateySuccess 'console2'
} catch {
  Write-ChocolateyFailure 'console2' "$($_.Exception.Message)"
  throw 
}
