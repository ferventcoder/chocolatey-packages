$fileName = 'IE9'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {$systemBit = '64 bit';}

#auto installers
#$urlToWin7_32bit = "http://view.atdmt.com/action/UMIRF_IE_IE9HP_Win7?href=http://download.microsoft.com/download/8/6/D/86DB5DC9-5706-4A5B-BD46-FFBA6FA67D44/IE9-Windows7-x86-enu.exe"
#$urlToWin7_64bit = "http://view.atdmt.com/action/UMIRF_IE_IE9HP_Win7?href=http://download.microsoft.com/download/8/6/D/86DB5DC9-5706-4A5B-BD46-FFBA6FA67D44/IE9-Windows7-x64-enu.exe"
#downloads the whole thing and gives you the option of no.
$urlToWin7_32bit = "http://view.atdmt.com/action/UMIRF_IE_IE9WW_InternationalDL?href=http://download.microsoft.com/download/C/3/B/C3BF2EF4-E764-430C-BDCE-479F2142FC81/IE9-Windows7-x86-enu.exe"
$urlToWin7_64bit = "http://view.atdmt.com/action/UMIRF_IE_IE9WW_InternationalDL?href=http://download.microsoft.com/download/C/1/6/C167B427-722E-4665-9A40-A37BC5222B0A/IE9-Windows7-x64-enu.exe"

$url = $urlToWin7_32bit;
if ($is64bit) { $url = $urlToWin7_64bit;}

Write-Host "Downloading $fileName for $winVersionName $systemBit to $file from $url"

$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName ..."
if ($fileType -like 'msi') {
  msiexec /i  "$file" /quiet
}
if ($fileType -like 'exe') {
Start-Process -FilePath $file -Wait #"/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer
#& "$file"
}

write-host "$fileName has been installed."
Start-Sleep 3