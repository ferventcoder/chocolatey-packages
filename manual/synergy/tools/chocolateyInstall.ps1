$packageName = 'synergy'
$packageVersion = '1.4.15'
$installerType = 'exe'
$url   = "http://synergy.googlecode.com/files/synergy-$packageVersion-Windows-x86.exe"
$url64 = "http://synergy.googlecode.com/files/synergy-$packageVersion-Windows-x64.exe"
$silentArgs = '/S'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
