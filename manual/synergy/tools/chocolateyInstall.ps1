$packageName = 'synergy'
$packageVersion = '1.7.3'
$installerType = 'msi'
$url   = "http://synergy-project.org/files/packages/synergy-v1.7.3-stable-efd0108-Windows-x86.msi"
$url64 = "http://synergy-project.org/files/packages/synergy-v1.7.3-stable-efd0108-Windows-x64.msi"
$silentArgs = '/quiet /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

