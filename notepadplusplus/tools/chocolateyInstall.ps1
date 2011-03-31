$fileName = 'notepadplusplus'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {$systemBit = '64 bit';}

$url = 'http://download.tuxfamily.org/notepadplus/5.8.7/npp.5.8.7.Installer.exe';
Write-Host "Downloading Notepad++ ( $url )."

$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing Notepad++ silently."

& "$file" "/S"

write-host "Notepad++ has been installed."
Start-Sleep 3