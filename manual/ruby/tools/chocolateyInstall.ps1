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
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p648.exe'
  # $checksum = '5d72154bb9bb8b0cefc161fa73b4de157c593b02'
  # $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p648-x64.exe'
  # $checksum64 = '8c60f9d71c45f21e95e2385508e7a010c0704467'

  # $rubyFolder = '21'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.8.exe?direct'
  # $checksum = '7f5e6956b971b44acfae09c51447f3d0132cd4fd'
  # $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.8-x64.exe?direct'
  # $checksum64 = 'e7419555f729a162719ebe9eb168456e431d33e8'

  #$rubyFolder = '22'
  #$url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.4.exe?direct'
  #$checksum = 'eb367be650482b63178845ced61892778e7d6a50'
  #$url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.4-x64.exe'
  #$checksum64 = '184b18eba6be931d7b03b8d15d6bfad3c9712718'

  $rubyFolder = '23'
  $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3.exe?direct'
  $checksum = '43110f9bcd8a067d69409507cad6a43f1fcf05e8bd64d096dd9df47475de50f3'
  $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3-x64.exe?direct'
  $checksum64 = '3d0a4ad06c5503e1cb88827443593969e689ac96b5161140b08f0becb7b792cf'
  
  $rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
  $silentArgs = "/verysilent /dir=`"$rubyPath`" /tasks=`"assocfiles,modpath`""

  # Install-ChocolateyPackage "$packageId" 'exe' "$silentArgs" "$url" -checksum $checksum

  Install-ChocolateyPackage "$packageId" 'exe' "$silentArgs" "$url" "$url64" -checksum $checksum -checksumType 'sha256' -checksum64 $checksum64 -checksumType64 'sha256'

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
