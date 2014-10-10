#auto installers
#$urlToWin7_32bit = "http://view.atdmt.com/action/UMIRF_IE_IE9HP_Win7?href=http://download.microsoft.com/download/8/6/D/86DB5DC9-5706-4A5B-BD46-FFBA6FA67D44/IE9-Windows7-x86-enu.exe"
#$urlToWin7_64bit = "http://view.atdmt.com/action/UMIRF_IE_IE9HP_Win7?href=http://download.microsoft.com/download/8/6/D/86DB5DC9-5706-4A5B-BD46-FFBA6FA67D44/IE9-Windows7-x64-enu.exe"
#downloads the whole thing and gives you the option of no.
$urlToWin7_32bit = "http://view.atdmt.com/action/UMIRF_IE_IE9WW_InternationalDL?href=http://download.microsoft.com/download/C/3/B/C3BF2EF4-E764-430C-BDCE-479F2142FC81/IE9-Windows7-x86-enu.exe"
$urlToWin7_64bit = "http://view.atdmt.com/action/UMIRF_IE_IE9WW_InternationalDL?href=http://download.microsoft.com/download/C/1/6/C167B427-722E-4665-9A40-A37BC5222B0A/IE9-Windows7-x64-enu.exe"
Install-ChocolateyPackage 'IE9' 'exe' '' "$urlToWin7_32bit" "$urlToWin7_64bit"

