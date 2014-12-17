$packageName = 'ie9'
$installerType = 'EXE'
$32BitUrl = 'http://download.microsoft.com/download/C/3/B/C3BF2EF4-E764-430C-BDCE-479F2142FC81/IE9-Windows7-x86-enu.exe'
$64BitUrl = 'http://download.microsoft.com/download/C/1/6/C167B427-722E-4665-9A40-A37BC5222B0A/IE9-Windows7-x64-enu.exe'
$silentArgs = '/Passive /NoRestart'
$validExitCodes = @(0,3010,40013) #3010: reboot required, 40013: already installed
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$32BitUrl" "$64BitUrl" -validExitCodes $validExitCodes
Write-Host 'You will likely need to restart your computer for the install to take effect.' -ForeGroundColor green