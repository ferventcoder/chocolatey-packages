try { 

  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 
  ### For BinRoot, use the following instead ###
  #$binRoot = "$env:systemdrive\"
  ### Using an environment variable to to define the bin root until we implement configuration ###
  #if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  #$installDir = Join-Path $binRoot 'httrack'
  #Write-Host "Adding `'$installDir`' to the path and the current shell path"
  #Install-ChocolateyPath "$installDir"
  #$env:Path = "$($env:Path);$installDir"
  $zipUrl = 'http://download.httrack.com/httrack-noinst-3.47.26.zip'
  $zipUrl64 = 'http://download.httrack.com/httrack_x64-noinst-3.47.26.zip'

  Install-ChocolateyZipPackage 'httrack.tool' "$zipUrl" "$installDir" "$zipUrl64"

  Write-ChocolateySuccess 'httrack.tool'
} catch {
  Write-ChocolateyFailure 'httrack.tool' "$($_.Exception.Message)"
  throw 
}