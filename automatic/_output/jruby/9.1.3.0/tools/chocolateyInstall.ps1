$packageName = 'jruby'
$installerType = 'exe'
$url = 'https://jruby.org.s3.amazonaws.com/downloads/9.1.3.0/jruby_windows_9_1_3_0.exe'
$url64 = 'https://jruby.org.s3.amazonaws.com/downloads/9.1.3.0/jruby_windows_x64_9_1_3_0.exe'
$silentArgs = '-q'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
