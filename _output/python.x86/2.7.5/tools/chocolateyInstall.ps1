try {
  $binRoot = "$env:systemdrive\"

  ### Using an environment variable to to define the bin root until we implement YAML configuration ###
  if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  $packageName = 'Python.x86'
  $fileType = 'msi'
  $silentArgs = "/qn TARGETDIR=$(join-path $binRoot 'Python27')"
  $url = 'http://www.python.org/ftp/python/2.7.5/python-2.7.5.msi'

  Install-ChocolateyPackage $packageName $fileType $silentArgs $url

  Install-ChocolateyPath $(join-path $binRoot 'Python27') 'User'

  Write-ChocolateySuccess 'python.x86'
} catch {
  Write-ChocolateyFailure 'python.x86' "$($_.Exception.Message)"
  throw
}
