$os = Get-WmiObject Win32_OperatingSystem
$winVersionName = $os.Caption
$winVer = $os.Version
$bitType = $os.OSArchitecture
$is64bit = $os.OSArchitecture -eq "64-bit"

#auto installers
#$urlToWin7_32bit = "http://view.atdmt.com/action/UMIRF_IE_IE9HP_Win7?href=http://download.microsoft.com/download/8/6/D/86DB5DC9-5706-4A5B-BD46-FFBA6FA67D44/IE9-Windows7-x86-enu.exe"
#$urlToWin7_64bit = "http://view.atdmt.com/action/UMIRF_IE_IE9HP_Win7?href=http://download.microsoft.com/download/8/6/D/86DB5DC9-5706-4A5B-BD46-FFBA6FA67D44/IE9-Windows7-x64-enu.exe"
#downloads the whole thing and gives you the option of no.
$urlToWin7_32bit = "http://view.atdmt.com/action/UMIRF_IE_IE9WW_InternationalDL?href=http://download.microsoft.com/download/C/3/B/C3BF2EF4-E764-430C-BDCE-479F2142FC81/IE9-Windows7-x86-enu.exe"
$urlToWin7_64bit = "http://view.atdmt.com/action/UMIRF_IE_IE9WW_InternationalDL?href=http://download.microsoft.com/download/C/1/6/C167B427-722E-4665-9A40-A37BC5222B0A/IE9-Windows7-x64-enu.exe"

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "IE9"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "IE9.exe"

$url = $urlToWin7_32bit;
if ($is64bit) { $url = $urlToWin7_64bit;}

Write-Host "Downloading IE9 for $winVersionName $bitType to $file from $url"

#http://bartdesmet.net/blogs/bart/archive/2006/11/25/PowerShell-_2D00_-How-to-download-a-file_3F00_.aspx
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

Invoke-Item $file
Start-Sleep 3