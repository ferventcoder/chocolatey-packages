$packageName = 'mingw'
$packageVersion = '4.8.3'
$rev = 'rev0'
$threads = 'posix'
$exceptionHandling = 'sjlj' #dwarf is 32bit only, seh is 64bit only, sjlj works with 32 / 64

$url = "http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/$packageVersion/threads-$threads/$exceptionHandling/i686-$packageVersion-release-$threads-$exceptionHandling-rt_v3-$rev.7z"
#http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/4.8.3/threads-posix/sjlj/i686-4.8.3-release-posix-sjlj-rt_v3-rev0.7z
$url64 = "http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/$packageVersion/threads-$threads/$exceptionHandling/x86_64-$packageVersion-release-$threads-$exceptionHandling-rt_v3-$rev.7z"
#http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/4.8.3/threads-posix/sjlj/x86_64-4.8.3-release-posix-sjlj-rev0.7z

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
  if (![System.IO.Directory]::Exists("$installDir\temp")) {[System.IO.Directory]::CreateDirectory("$installDir\temp")}
  Start-Process "7za" -ArgumentList "x -o`"$installDir\temp`" -y `"$file`"" -Wait

  if (Get-ProcessorBits 64) {
    Copy-Item "$($installDir)\temp\mingw64\*" "$($installDir)" -Force -Recurse
  } else {
    Copy-Item "$($installDir)\temp\mingw32\*" "$($installDir)" -Force -Recurse
  }

  try {
    Remove-Item "$($installDir)\temp\" -Force -Recurse
  } catch {
    Write-Warning "Could not remove `"$($installDir)\temp\`". Please remove manually."
  }

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}

