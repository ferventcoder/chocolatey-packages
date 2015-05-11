$packageName = 'ruby.portable'

# 1.8.7
#$url = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.8.7-p374-i386-mingw32.7z?direct'
#$checksum = '2eabeb3bb210d088083c0c04fdf94c7e'

# 1.9.3
# $url = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.9.3-p551-i386-mingw32.7z?direct'
# $checksum = '73ba6e292d3afec5cecc68ec64fd85bf'

# 2.0.0
$url = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.0.0-p645-i386-mingw32.7z?direct'
$checksum = '57422903090e7001698c5b94ca47e1a6ee492c54'
$url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.0.0-p645-x64-mingw32.7z?direct'
$checksum64 = 'af37b28c15449d7adf05acd0717a9804460d8738'

# 2.1.5
#$url = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-i386-mingw32.7z?direct'
#$checksum = 'fe6b596fc47f503b0c0c01ebed16cf65'
#$url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-x64-mingw32.7z?direct'
#$checksum64 = '2ebc791db99858a0bd586968cddfcf0d'

try {
  $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $installDir = Join-Path $toolsDir "ruby"


  $file = Join-Path $toolsDir "$($packageName).7z"
  #Get-ChocolateyWebFile "$packageName" "$file" "$url" -checksum "$checksum"
  Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"
  #Checksum type sha1 has a bug fixed in 0.9.9.6 - https://github.com/chocolatey/choco/issues/253
  #-checksum $checksum -checksumType 'sha1' -checksum64 $checksum64 -checksumType64 'sha1'

  Get-ChocolateyUnzip "$file" "$installDir" -packageName "$packageName"

  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
