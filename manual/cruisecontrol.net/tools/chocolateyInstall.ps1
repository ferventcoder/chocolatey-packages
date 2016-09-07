$packageName = 'cruisecontrol.net'
$installerType = 'EXE'
$32BitUrl = 'https://downloads.sourceforge.net/project/ccnet/CruiseControl.NET%20Releases/CruiseControl.NET%201.8.5/CruiseControl.NET-1.8.5.0-Setup.exe'
$silentArgs = '/S'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$32BitUrl" -validExitCodes $validExitCodes
