$fileName = 'launchy'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {$systemBit = '64 bit';}

$url = 'http://www.launchy.net/downloads/win/Launchy2.5.exe';

Write-Host "Downloading $fileName to $file from $url"

$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName silently..."

Start-Process -FilePath $file -ArgumentList "/silent" -Wait #"/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer
#& "$file" "/silent"

write-host "$fileName has been installed. Start $fileName from the Start Menu. Then press Left Alt + Space for options and to use."
Start-Sleep 3