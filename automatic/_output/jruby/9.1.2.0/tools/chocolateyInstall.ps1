$packageName = 'jruby'
$installerType = 'exe'
$url = 'http://jruby.org.s3.amazonaws.com/downloads/9.1.2.0/jruby_windows_9_1_2_0.exe'
$url64 = 'http://jruby.org.s3.amazonaws.com/downloads/9.1.2.0/jruby_windows_x64_9_1_2_0.exe'
$silentArgs = '-q'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
