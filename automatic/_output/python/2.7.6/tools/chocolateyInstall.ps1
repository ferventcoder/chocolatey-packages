try {
  $binRoot = "$env:systemdrive\"

  ### Using an environment variable to to define the bin root until we implement YAML configuration ###
  if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  $packageName = 'Python'
  $fileType = 'msi'
  $silentArgs = "/qn TARGETDIR=$(join-path $binRoot 'Python27')"
  $url = 'http://www.python.org/ftp/python/2.7.6/python-2.7.6.msi'
  $url64bit = 'http://www.python.org/ftp/python/2.7.6/python-2.7.6.amd64.msi'

  Install-ChocolateyPackage $packageName $fileType $silentArgs $url $url64bit

  Install-ChocolateyPath $(join-path $binRoot 'Python27') 'User'

  Write-ChocolateySuccess 'python'
} catch {
  Write-ChocolateyFailure 'python' "$($_.Exception.Message)"
  throw 
}