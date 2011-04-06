$fileName = 'lockhunter'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$url = 'http://lockhunter.com/lockhuntersetup32.exe'

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {
  $systemBit = '64 bit';
  $url = 'http://lockhunter.com/lockhuntersetup64.exe';
}

Write-Host "Downloading $fileName $systemBit to $file from $url"
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName $systemBit silently..."
Start-Process -FilePath $file -ArgumentList "/SILENT" -Wait
write-host "$fileName $systemBit has been installed."

Start-Sleep 3