$packageName = 'jruby'
$installerType = 'exe'
$url = 'http://jruby.org.s3.amazonaws.com/downloads/1.7.16.2/jruby_windows_1_7_16_2.exe'
$url64 = 'http://jruby.org.s3.amazonaws.com/downloads/1.7.16.2/jruby_windows_x64_1_7_16_2.exe'
$silentArgs = '-q'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
