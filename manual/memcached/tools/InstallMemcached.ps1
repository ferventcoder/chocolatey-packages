try {
  #binaries
  #http://blog.elijaa.org/index.php?post/2010/10/15/Memcached-for-Windows
  #http://code.jellycan.com/memcached/

  #installing and running
  #http://www.codeforest.net/how-to-install-memcached-on-windows-machine
  #http://blog.elijaa.org/index.php?post/2010/04/02/Installing-memcached-1.4.4-on-Windows
  #http://blog.smarx.com/posts/memcached-in-windows-azure

  #build your own binaries
  #http://trondn.blogspot.com/2010/03/building-memcached-windows.html

  #1.4.5 is broken...

  $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $memcachedPackageDir = Join-Path $toolsDir 'memcached'

  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  if ($is64bit) {
    $memcachedPackageDir = Join-Path $memcachedPackageDir 'x64'
  } else {
    $memcachedPackageDir = Join-Path $memcachedPackageDir 'x86'
  }

  $binRoot = "$env:systemdrive\"
  ### Using an environment variable to to define the bin root until we implement YAML configuration ###
  if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}

  $memcachedInstallDir = join-path $binRoot 'memcached'
  $memcached = join-path $memcachedInstallDir 'memcached.exe'

  if(test-path $memcached){
    Write-Host "memcached found at `'$memcached`'. Shutting down and uninstalling..."
  try {
    & sc stop memcached
  } catch {
      Write-Host 'Reverting to the old shutdown method memcached -d shutdown for 1.2.* versions.'
    & $memcached -d shutdown
  }

    Start-Sleep 2
  try {
    & sc delete memcached
  } catch {
    Write-Host 'Reverting to the old shutdown method memcached -d uninstall for 1.2.* versions.'
    & $memcached -d uninstall
  }

    Write-Host "Removing files at `'$memcachedInstallDir`'."
    remove-item $memcachedInstallDir -recurse -force
  }

  if (![System.IO.Directory]::Exists($memcachedInstallDir)) {[System.IO.Directory]::CreateDirectory($memcachedInstallDir)}
  Copy-Item "$($memcachedPackageDir)\*" "$memcachedInstallDir" -Force -Recurse
  Install-ChocolateyPath "$memcachedPath"

  Write-Host "Installing memcached at `'$memcached`'"
  Start-Process "sc.exe" -ArgumentList "create memcached binPath= `"$($memcached) -m 512`" start= auto" -Wait
  Start-Sleep 3

  Write-Host "Starting memcached at `'$memcached`'"
  & SC start memcached

  Write-ChocolateySuccess 'memcached'
} catch {
  Write-ChocolateyFailure 'memcached' "$($_.Exception.Message)"
  throw
}
