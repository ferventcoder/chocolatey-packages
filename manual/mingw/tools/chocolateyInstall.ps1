. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) chocolateyInclude.ps1)

$url = "http://downloads.sourceforge.net/mingw-w64/$zipFile"
#http://downloads.sourceforge.net/mingw-w64/i686-4.8.3-release-posix-sjlj-rt_v3-rev0.7z
#http://downloads.sourceforge.net/mingw-w64/x86_64-4.8.3-release-posix-sjlj-rev0.7z

$binRoot = Get-BinRoot
Write-Debug "Bin Root is $binRoot"

Install-ChocolateyZipPackage "$packageName" "$url" "$binRoot" -checksum "$checksum" -checksumType 'sha1'

$installDir = Join-Path "$binRoot" "$mingwDir"
Write-Host "Adding `'$installDir`' to the path and the current shell path"
Install-ChocolateyPath "$installDir\bin"
$env:Path = "$($env:Path);$installDir\bin"
