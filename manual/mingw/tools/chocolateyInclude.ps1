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

# Select 32-bit or 64-bit install. We're explicit here rather than depending on helpers so we can
# accurately set PATH.
$forceX86 = $env:chocolateyForceX86;
if (($forceX86) -or (Get-ProcessorBits 32)) {
  Write-Debug "installing mingw-w64 32-bit"
  if ($exception -eq 'default') {
    $exception = 'sjlj'
  } elseif (($exception -ne 'sjlj') -and ($exception -ne 'dwarf')) {
    Write-Host "Unknown value $exception for exception parameter, expected 'dwarf' or 'sjlj'; using sjlj"
    $exception = 'sjlj'
  }
  $mingwDir = 'mingw32'
  $prefix = 'i686'
} else {
  Write-Debug "installing mingw-w64 64-bit"
  if ($exception -eq 'default') {
    $exception = 'seh'
  } elseif (($exception -ne 'sjlj') -and ($exception -ne 'seh')) {
    Write-Host "Unknown value $exception for exception parameter, expected 'seh' or 'sjlj'; using seh"
    $exception = 'seh'
  }
  $mingwDir = 'mingw64'
  $prefix = 'x86_64'
}

$zipFile = "$prefix-$packageVersion-release-$threads-$exception-rt_v3-$rev.7z"
