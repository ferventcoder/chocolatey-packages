$packageName = 'ie9'
$installerType = 'EXE'
$32BitUrls = @{
	'en'='http://download.microsoft.com/download/C/3/B/C3BF2EF4-E764-430C-BDCE-479F2142FC81/IE9-Windows7-x86-enu.exe';
	'de'='http://download.microsoft.com/download/F/6/4/F6414410-F454-43BA-834E-1B4A7C1E774C/IE9-Windows7-x86-deu.exe';
}
$64BitUrls = @{
	'en'='http://download.microsoft.com/download/C/1/6/C167B427-722E-4665-9A40-A37BC5222B0A/IE9-Windows7-x64-enu.exe';
	'de'='http://download.microsoft.com/download/B/B/B/BBBB0466-AE6E-46B9-AFE8-523A6C9E4232/IE9-Windows7-x64-deu.exe';
}
$silentArgs = '/Passive /NoRestart'
$validExitCodes = @(0,3010,40013) #3010: reboot required, 40013: already installed

Write-Debug "Detecting Locale..."
$locale = (Get-Culture).TwoLetterISOLanguageName
if ($32BitUrls.ContainsKey($locale)) {
	Write-Host "Switching to $locale"
} else {
	$locale = 'en';
	Write-Debug "Using default $locale"
}
$32BitUrl = $32BitUrls.Get_Item($locale);
$64BitUrl = $64BitUrls.Get_Item($locale);
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$32BitUrl" "$64BitUrl" -validExitCodes $validExitCodes
Write-Host 'You will likely need to restart your computer for the install to take effect.' -ForeGroundColor green