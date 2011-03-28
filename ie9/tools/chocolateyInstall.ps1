$url = "http://view.atdmt.com/action/UMIRF_IE_IE9WW_InternationalDL?href=http://download.microsoft.com/download/C/1/6/C167B427-722E-4665-9A40-A37BC5222B0A/IE9-Windows7-x64-enu.exe"

$tempDir = Join-Path $env:TEMP "IE9"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

$file = Join-Path $tempDir "IE9-Windows7-x64-enu.exe"

Write-Host "Downloading IE9 for Windows7 x64 to $file from $url"

#http://bartdesmet.net/blogs/bart/archive/2006/11/25/PowerShell-_2D00_-How-to-download-a-file_3F00_.aspx
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

Invoke-Item $file