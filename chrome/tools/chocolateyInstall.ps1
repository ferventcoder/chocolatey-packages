$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "chrome"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "chrome_installer.exe"

$url = 'http://cache.pack.google.com/edgedl/chrome/install/648.204/chrome_installer.exe'

Write-Host "Downloading Google Chrome to $file from $url"

#http://bartdesmet.net/blogs/bart/archive/2006/11/25/PowerShell-_2D00_-How-to-download-a-file_3F00_.aspx
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

& "$file" "/silent"

write-host "Google Chrome has been installed."