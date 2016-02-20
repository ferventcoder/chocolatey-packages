try {

  $packageId = 'ruby'
  $binRoot = Get-BinRoot

  # $rubyFolder = '187'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.8.7-p374.exe?direct'
  # $checksum = '2e33a098f126275f7cb29ddcd0eb9845'

  # $rubyFolder = '193'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.9.3-p551.exe?direct'
  # $checksum = '25de5ff94b76d7d308cb75ba8179a6c0'

  # $rubyFolder = '200'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p645.exe?direct'
  # $checksum = 'cb25a38508e22a869b48df7974840eb78c77635c'
  # $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p645-x64.exe?direct'
  # $checksum64 = '8f8f39d69a222b5472254969755ff5d36dc42585'

  # $rubyFolder = '21'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.7.exe?direct'
  # $checksum = '57efcc7ea3e031e66e2951db85ed09fe'
  # $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.7-x64.exe?direct'
  # $checksum64 = '56751f595ecc5385008967c5c582027e'

  $rubyFolder = '22'
  $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.3.exe?direct'
  $checksum = '2da40c04d7a3906b269e739b5627304f'
  $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.3-x64.exe?direct'
  $checksum64 = '9f123f08f1045ad1d49a99031f3e835e'

  $rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
  $silentArgs = "/verysilent /dir=`"$rubyPath`" /tasks=`"assocfiles,modpath`""

  # Install-ChocolateyPackage "$packageId" 'exe' "$silentArgs" "$url" -checksum $checksum
  Install-ChocolateyPackage "$packageId" 'exe' "$silentArgs" "$url" "$url64"
  #Checksum type sha1 has a bug fixed in 0.9.9.6 - https://github.com/chocolatey/choco/issues/253
  #-checksum $checksum -checksumType 'md5' -checksum64 $checksum64 -checksumType64 'md5'

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
