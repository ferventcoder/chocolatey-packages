$packageName = 'mingw'
#$url = 'http://downloads.sourceforge.net/project/mingw/Installer/mingw-get-setup.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmingw%2Ffiles%2FInstaller%2F&ts=1384035674&use_mirror=superb-dca2' # download url
$url = 'http://downloads.sourceforge.net/project/mingwbuilds/host-windows/releases/4.7.2/32-bit/threads-posix/sjlj/x32-4.7.2-release-posix-sjlj-rev2.7z'
#       http://downloads.sourceforge.net/project/mingwbuilds/host-windows/releases/4.7.2/32-bit/threads-posix/sjlj/x32-4.7.2-release-posix-sjlj-rev2.7z?r=&ts=1384174340&use_mirror=superb-dca2
$url64 = 'http://downloads.sourceforge.net/project/mingwbuilds/host-windows/releases/4.7.2/64-bit/threads-posix/sjlj/x64-4.7.2-release-posix-sjlj-rev2.7z'
#http://downloads.sourceforge.net/project/mingwbuilds/host-windows/releases/4.7.2/32-bit/threads-posix/sjlj/x32-4.7.2-release-posix-sjlj-rev2.7z
try {

  $binRoot = Get-BinRoot
  Write-Debug "Bin Root is $binRoot"
  $installDir = Join-Path "$binRoot" 'MinGW'
  Write-Host "Adding `'$installDir`' to the path and the current shell path"
  Install-ChocolateyPath "$installDir\bin"
  $env:Path = "$($env:Path);$installDir\bin"

  if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir)}

  $tempDir = "$env:TEMP\chocolatey\$($packageName)"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

  $file = Join-Path $tempDir "$($packageName).7z"
  Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"
  Write-Host "Extracting `'$file`' to `'$installDir`'"
  Start-Process "7za" -ArgumentList "x -o`"$installDir\temp`" -y `"$file`"" -Wait
  Copy-Item "$($installDir)\temp\mingw\*" "$($installDir)" -Force -Recurse

  # if (Get-ProcessorBits 64) {
  #   # unzip 64 bit on top of 32 bit
  #   $file = Join-Path $tempDir "$($packageName)-64.7z"
  #   Get-ChocolateyWebFile "$packageName" "$file" "$url64"
  #   Write-Host "Extracting `'$file`' to `'$installDir`'"
  #   Start-Process "7za" -ArgumentList "x -o`"$installDir\temp`" -y `"$file`"" -Wait
  #   Copy-Item "$($installDir)\temp\mingw\*" "$($installDir)" -Force -Recurse
  # }

  Remove-Item "$($installDir)\temp\" -Force -Recurse

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
