$packageName = 'ruby.portable'
# $url = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.8.7-p374-i386-mingw32.7z?direct'
# $checksum = '2eabeb3bb210d088083c0c04fdf94c7e'
$url = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.9.3-p545-i386-mingw32.7z?direct'
$checksum = '8e7f07256c86bfd6fc73fbcc13db4b09'
# $url = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.0.0-p481-i386-mingw32.7z?direct'
# $checksum = '1a43404393f080e0225509415866307b'
# $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.0.0-p481-x64-mingw32.7z?direct'
# $checksum64 = '61a3f9d707ea3bf5af57de29d463b191'

try {
  $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $installDir = Join-Path $toolsDir "ruby"


  $file = Join-Path $toolsDir "$($packageName).7z"
  Get-ChocolateyWebFile "$packageName" "$file" "$url" -checksum "$checksum"
  #Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64" -checksum "$checksum" -checksum64 "$checksum64"

  if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir)}
  Start-Process "7za" -ArgumentList "x -o`"$installDir`" -y `"$file`"" -Wait

  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
