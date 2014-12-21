try {

  $packageId = 'ruby'
  $binRoot = Get-BinRoot

  $rubyFolder = '215'
  $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.5.exe?direct'
  $checksum = 'eacd2526ef61fb73c0e642828675e94d'
  $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.5-x64.exe?direct'
  $checksum64 = '3aad5fbfe6bfcf9cf3237ed9f048b81f'

  $rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
  $silentArgs = "/verysilent /dir=`"$rubyPath`" /tasks=`"assocfiles,modpath`""

  Install-ChocolateyPackage "$packageId" 'exe' "$silentArgs" "$url" "$url64" #-checksum $checksum -checksum64 $checksum64

  $rubyBin = join-path $rubyPath 'bin'
  Write-Host "Adding `'$rubyBin`' to the local path"
  $env:Path = "$($env:Path);$rubyBin"

  # # Install and configure pik
  # Write-Host "Now we are going to install pik and set up the folder - so Ruby is pointed to the correct version"
  # $nugetBin = join-path $env:ChocolateyInstall 'bin'
  # #$gem = 'gem.bat'
  # $pikInstall = 'pik_install.bat'
  # & gem install pik
  # & $pikInstall "$nugetBin"

  # & pik add $rubyBin
  # & pik use $rubyFolder

} catch {
  Write-ChocolateyFailure "$packageId" $($_.Exception.Message)
  throw
}
