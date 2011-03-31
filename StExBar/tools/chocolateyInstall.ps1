$fileName = 'StExBar'
$fileType = 'msi' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {$systemBit = '64 bit';}

$url32bit = 'http://stexbar.googlecode.com/files/StExBar-1.8.2.msi'
$url64bit = 'http://stexbar.googlecode.com/files/StExBar64-1.8.2.msi'
$url = $url32bit
if ($is64bit) { $url = $url64bit; }

Write-Host "Downloading $fileName $systemBit to $file from $url"

$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName $systemBit silently..."
if ($fileType -like 'msi') {
  msiexec /i  "$file" /quiet
}
if ($fileType -like 'exe') {
& "$file" "/S" #"/s /S /q /Q /quiet /silent" # try any of these to get the silent installer
}

write-host "$fileName $systemBit has been installed."
Start-Sleep 3