try {
  $packageName = 'sysinternals'
  $url = 'http://download.sysinternals.com/files/SysinternalsSuite.zip'

  ### Using an environment variable to to define the bin root until we implement YAML configuration ###
  $binRoot = "$env:systemdrive\"
  if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  $installDir = join-path $binRoot $packageName

  Install-ChocolateyZipPackage $packageName $url $installDir

  Install-ChocolateyPath $installDir 'User'

  # Delete any existing batch files from an earlier install
  if ($env:chocolateyinstall -ne $null) {
    $nugetBin = join-path $env:chocolateyinstall 'bin'
    $files = get-childitem $installDir -include *.exe -recurse
    foreach ($file in $files) {
      try {
          $batchFile = join-path $nugetBin ($file.Name.Replace(".exe",".bat").Replace(".EXE",".bat"))
          if(test-path $batchFile){
            remove-item $batchFile
        }
      }catch {}
    }
  }

  
  Write-ChocolateySuccess 'sysinternals'
} catch {
  Write-ChocolateyFailure 'sysinternals' $($_.Exception.Message)
  throw
}
