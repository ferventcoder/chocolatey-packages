# Default values
$packageName = 'mingw'
$packageVersion = '4.9.3'
$rev = 'v4-rev1'
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
      'sjlj'='008bd533810a2c8e64c86e671a1c0230d6f521be';
      'seh'='cbaf53864cc4f86a27e0c84b9bdced0b7580dd7c'
    };
    'win32'=@{
      'sjlj'='193af7cf78d3d814ae7e6172cc44d36d59214631';
      'seh'='754fdd027a6378680139914ba4323d99b754bd64'
    }
  };
  'i686'=@{
    'posix'=@{
      'sjlj'='df6ab0f7dd12333a0492c35cd5e85ae003054171';
      'dwarf'='210c177322dec580198cb41862b4ed60a521deb0'
    };
    'win32'=@{
      'sjlj'='3efbd8eaa740da50b1212a76bcad34a59114b644';
      'dwarf'='06b342885f82ed07f114890d4b14e836dae7362e'
    }
  }
}
$checksum = $checksums[$prefix][$threads][$exception]

$zipFile = "$prefix-$packageVersion-release-$threads-$exception-rt_$rev.7z"
