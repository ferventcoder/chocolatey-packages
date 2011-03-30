$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "launchy"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "Launchy.exe"

$url = 'http://www.launchy.net/downloads/win/Launchy2.5.exe';
Write-Host "Downloading Launchy ( $url )."

#http://bartdesmet.net/blogs/bart/archive/2006/11/25/PowerShell-_2D00_-How-to-download-a-file_3F00_.aspx
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing Launchy silently."

& "$file" "/silent"

write-host "Launchy has been installed. Start Launchy from the Start Menu. Then press Left Alt + Space for options and to use."
Start-Sleep 3