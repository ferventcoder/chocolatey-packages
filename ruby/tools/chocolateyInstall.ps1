try {

  # This should be the preferred method
  #$binRoot = Get-BinRoot
	
  # Calculate $binRoot
  if($env:chocolatey_bin_root -eq $null) {
    $binRoot = "$env:ChocolateyInstall\bin"
  }
  # My chocolatey_bin_root is C:\Common\bin, but looking at other packages, not everyone assumes chocolatey_bin_root is prepended with a drive letter.
  elseIf (-not($env:chocolatey_bin_root -imatch "^\w:")) {
    # Add drive letter
    $binRoot = join-path $env:systemdrive $env:chocolatey_bin_root
  }
  else {
    $binRoot = $env:chocolatey_bin_root
  }

  # $rubyFolder = '187'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.8.7-p374.exe?direct'

  # $rubyFolder = '193'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.9.3-p448.exe?direct'

  $rubyFolder = '200'
  $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p247.exe?direct'

  $rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
  $silentArgs = "/verysilent /dir=`"$rubyPath`" /tasks=`"assocfiles,modpath`""

  Install-ChocolateyPackage 'ruby' 'exe' "$silentArgs" "$url"

  # # Install and configure pik
  # Write-Host "Now we are going to install pik and set up the folder - so Ruby is pointed to the correct version"
  $rubyBin = join-path $rubyPath 'bin'
  Write-Host "Adding `'$rubyBin`' to the local path"
  $env:Path = "$($env:Path);$rubyBin"
  
  # $nugetBin = join-path $env:ChocolateyInstall 'bin'
  # #$gem = 'gem.bat'
  # $pikInstall = 'pik_install.bat'
  # & gem install pik
  # & $pikInstall "$nugetBin"

  # & pik add $rubyBin
  # & pik use $rubyFolder

  Write-ChocolateySuccess 'ruby'
} catch {
  Write-ChocolateyFailure 'ruby' $($_.Exception.Message)
  throw
}
