$packageName = 'jruby'
$installerType = 'exe'
$url = 'http://jruby.org.s3.amazonaws.com/downloads/9.0.1.0/jruby_windows_9_0_1_0.exe'
$url64 = 'http://jruby.org.s3.amazonaws.com/downloads/9.0.1.0/jruby_windows_x64_9_0_1_0.exe'
$silentArgs = '-q'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
