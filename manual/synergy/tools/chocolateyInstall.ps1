$packageName = 'synergy'
$packageVersion = '1.5.0'
$installerType = 'msi'
$url   = "http://synergy-project.org/files/packages/synergy-1.5.0-r2278-Windows-x86.msi"
$url64 = "http://synergy-project.org/files/packages/synergy-1.5.0-r2278-Windows-x64.msi"
$silentArgs = '/quiet /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

