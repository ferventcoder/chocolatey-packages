# Default values
$packageName = 'mingw'
$packageVersion = '4.8.3'
$rev = 'rev0'
$threads = 'posix'
$exception = 'default' #dwarf is 32bit only, seh is 64bit only, sjlj works with 32 / 64

$arguments = @{}
$packageParameters = $env:chocolateyPackageParameters

if($packageParameters) {
  $MATCH_PATTERN = "/([a-zA-Z]+):([a-zA-Z0-9]+)"
  $PARAMATER_NAME_INDEX = 1
  $VALUE_INDEX = 2

  if($packageParameters -match $MATCH_PATTERN ){
    $results = $packageParameters | Select-String $MATCH_PATTERN -AllMatches
    $results.matches | % {
      $arguments.Add(
        $_.Groups[$PARAMATER_NAME_INDEX].Value.Trim(),
        $_.Groups[$VALUE_INDEX].Value.Trim())
    }
  }

  if($arguments.ContainsKey("exception")) {
    Write-Host "Exception Argument Found"
    $exception = $arguments["exception"]
  }

  if($arguments.ContainsKey("threads")) {
    Write-Host "Threads Argument Found"
    $threads = $arguments["threads"]
  }
}

if (Get-ProcessorBits 64) {
  $mingwDir = 'mingw64'
} else {
  $mingwDir = 'mingw32'
}

if ($exception -eq 'sjlj') {
  $exceptionHandling = 'sjlj'
  $exceptionHandling64 = 'sjlj'
} else {
  if ($exception -ne 'default') {
    Write-Host "Unknown value $exception for exception parameter, using defaults"
  }
  $exceptionHandling = 'dwarf'
  $exceptionHandling64 = 'seh'
}

$url = "http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/$packageVersion/threads-$threads/$exceptionHandling/i686-$packageVersion-release-$threads-$exceptionHandling-rt_v3-$rev.7z"
#http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/4.8.3/threads-posix/sjlj/i686-4.8.3-release-posix-sjlj-rt_v3-rev0.7z
$url64 = "http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/$packageVersion/threads-$threads/$exceptionHandling64/x86_64-$packageVersion-release-$threads-$exceptionHandling64-rt_v3-$rev.7z"
#http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/4.8.3/threads-posix/sjlj/x86_64-4.8.3-release-posix-sjlj-rev0.7z

$binRoot = Get-BinRoot
Write-Debug "Bin Root is $binRoot"

Install-ChocolateyZipPackage "$packageName" "$url" "$binRoot" "$url64"

$installDir = Join-Path "$binRoot" "$mingwDir"
Write-Host "Adding `'$installDir`' to the path and the current shell path"
Install-ChocolateyPath "$installDir\bin"
$env:Path = "$($env:Path);$installDir\bin"
