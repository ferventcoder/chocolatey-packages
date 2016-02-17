# Default values
$packageName = 'mingw'
$packageVersion = '5.3.0'
$rev = 'v4-rev0'
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

# sha1 checksums
$checksums = @{
  'x86_64'=@{
    'posix'=@{
      'sjlj'='4f9c17b30ff18c2d3d7cb8cb5f3a1ac9aa84b868';
      'seh'='7eb12dd3eddcf609722c9552f8592bd9948da1fc'
    };
    'win32'=@{
      'sjlj'='414bc5cee8dbff934c49b551c3ac3a17041614c5';
      'seh'='164df21c5131733b70a3e8ad4373485ee32731ed'
    }
  };
  'i686'=@{
    'posix'=@{
      'sjlj'='91b10f23917b59d6e2b9e88233d26854f58b9ea2';
      'dwarf'='d4f21d25f3454f8efdada50e5ad799a0a9e07c6a'
    };
    'win32'=@{
      'sjlj'='719cd0700ed90fd534abd059f2335c80fa2b132a';
      'dwarf'='b62298b55a9e7eef68b17cea359d3e281994082b'
    }
  }
}
$checksum = $checksums[$prefix][$threads][$exception]

$zipFile = "$prefix-$packageVersion-release-$threads-$exception-rt_$rev.7z"
