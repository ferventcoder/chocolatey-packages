$packageName = 'jruby'
$installerType = 'exe'
$url = 'http://jruby.org.s3.amazonaws.com/downloads/1.7.10/jruby_windows_1_7_10.exe'
$url64 = 'http://jruby.org.s3.amazonaws.com/downloads/1.7.10/jruby_windows_x64_1_7_10.exe'
$silentArgs = '-q'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

