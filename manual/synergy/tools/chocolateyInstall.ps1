$packageName = 'synergy'
$packageVersion = '1.7.5'
$installerType = 'msi'
$url   = "http://synergy-project.org/files/packages/synergy-v1.7.5-stable-fa85a24-Windows-x86.msi"
$url64 = "http://synergy-project.org/files/packages/synergy-v1.7.5-stable-fa85a24-Windows-x64.msi"
$silentArgs = '/quiet /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

