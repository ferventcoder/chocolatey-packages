try{
  $mydir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  $contentSettingsFile = ($mydir | Split-Path | Join-Path -ChildPath "content" | Join-Path -ChildPath "console.xml")
  $binSettingsFile = ($mydir | Split-Path | Join-Path -ChildPath "bin" | Join-Path -ChildPath "console.xml")

  if(!(test-path $binSettingsFile)) {
      Write-Host "Creating default settings file from $contentSettingsFile"
      copy-item $contentSettingsFile $binSettingsFile
  }

  Write-ChocolateySuccess 'console2'
} catch {
  Write-ChocolateyFailure 'console2' "$($_.Exception.Message)"
  throw 
}
