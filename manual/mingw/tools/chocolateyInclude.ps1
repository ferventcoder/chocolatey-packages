# Default values
$packageName = 'mingw'
$packageVersion = '4.8.5'
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
      'sjlj'='12b38db95f053b820dedbf4b226035abcfe3fab6';
      'seh'='715b01ca06d7fd2d813f67d0cd536d751cef0f15'
    };
    'win32'=@{
      'sjlj'='896d065baf8e487a424a1292148eaea5413a755b';
      'seh'='c664898f4cf69b8af0c394096d41eb56c0ac76b2'
    }
  };
  'i686'=@{
    'posix'=@{
      'sjlj'='b0130c84e274c0f1702d24a2c83f900446156f63';
      'dwarf'='7372de484727d78ff38af0042de1dacc7b657c2f'
    };
    'win32'=@{
      'sjlj'='88f2ff4c827ea10a7c60b1db58810e9f00e04d9e';
      'dwarf'='6688a67032b7582a531645b22523d92e0aad61ab'
    }
  }
}
$checksum = $checksums[$prefix][$threads][$exception]

$zipFile = "$prefix-$packageVersion-release-$threads-$exception-rt_$rev.7z"
