$packageName = 'ie9'
$installerType = 'EXE'
if ([Environment]::OSVersion.Version -lt (new-object 'Version' 6,1)) {
	Write-Debug 'Using URLs for Windows VISTA and Server 2008'
	$32BitUrls = @{
		'en'='http://download.microsoft.com/download/0/8/7/08768091-35BC-48E0-9F7F-B9802A0EE2D6/IE9-WindowsVista-x86-enu.exe';
		'de'='http://download.microsoft.com/download/1/E/9/1E9DE3C7-0C84-41C8-BBED-997EB0C98CCA/IE9-WindowsVista-x86-deu.exe';
		'fr'='http://download.microsoft.com/download/2/D/A/2DA4583E-D889-4589-8DAF-71C6EE874A49/IE9-WindowsVista-x86-fra.exe';
		'es'='http://download.microsoft.com/download/6/7/6/67666836-7A97-48D9-82BD-6E76B2A9D659/IE9-WindowsVista-x86-esn.exe';
		'nl'='http://download.microsoft.com/download/5/F/9/5F9BCA6C-835C-4B38-B6AE-6D5B62DE048D/IE9-WindowsVista-x86-nld.exe';
		'ja'='http://download.microsoft.com/download/6/C/0/6C003240-6F63-4FC0-82EE-C451BF00A50D/IE9-WindowsVista-x86-jpn.exe';
	}
	$64BitUrls = @{
		'en'='http://download.microsoft.com/download/7/C/3/7C3BA535-1D8C-4A87-9F1D-163BBA971CA9/IE9-WindowsVista-x64-enu.exe';
		'de'='http://download.microsoft.com/download/8/3/2/83205D42-C4DE-435E-AF10-4919CBDB3A13/IE9-WindowsVista-x64-deu.exe';
		'fr'='http://download.microsoft.com/download/3/0/1/301FFBDB-AB53-4309-BB2F-C041BC09B782/IE9-WindowsVista-x64-fra.exe';
		'es'='http://download.microsoft.com/download/7/2/2/722AEF58-EE19-4051-AB2A-236E71B859F4/IE9-WindowsVista-x64-esn.exe';
		'nl'='http://download.microsoft.com/download/D/E/B/DEB51A98-9013-440C-9D9D-FCD3A23BEB39/IE9-WindowsVista-x64-nld.exe';
		'ja'='http://download.microsoft.com/download/5/1/F/51F0DA3B-831A-46D6-9132-6329FAEB0379/IE9-WindowsVista-x64-jpn.exe';
	}
} else {
	Write-Debug 'Using URLs for URLs for Windows 7 and Server 2008 R2'
	$32BitUrls = @{
		'en'='http://download.microsoft.com/download/C/3/B/C3BF2EF4-E764-430C-BDCE-479F2142FC81/IE9-Windows7-x86-enu.exe';
		'de'='http://download.microsoft.com/download/F/6/4/F6414410-F454-43BA-834E-1B4A7C1E774C/IE9-Windows7-x86-deu.exe';
	}
	$64BitUrls = @{
		'en'='http://download.microsoft.com/download/C/1/6/C167B427-722E-4665-9A40-A37BC5222B0A/IE9-Windows7-x64-enu.exe';
		'de'='http://download.microsoft.com/download/B/B/B/BBBB0466-AE6E-46B9-AFE8-523A6C9E4232/IE9-Windows7-x64-deu.exe';
	}
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