$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "notepadplusplus"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "notepadplusplus.exe"

$url = 'http://download.tuxfamily.org/notepadplus/5.8.7/npp.5.8.7.Installer.exe';
Write-Host "Downloading Notepad++ ( $url )."

#http://bartdesmet.net/blogs/bart/archive/2006/11/25/PowerShell-_2D00_-How-to-download-a-file_3F00_.aspx
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing Notepad++ silently."

& "$file" "/S"

write-host "Notepad++ has been installed."
Start-Sleep 3