$fileName = '7Zip'
$fileType = 'msi'
$os = Get-WmiObject Win32_OperatingSystem
$systemBit = $os.OSArchitecture
$is64bit = $os.OSArchitecture -eq "64-bit"

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$url32bit = 'http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.20/7z920.msi?r=&ts=1301509610&use_mirror=iweb'
$url64bit = 'http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.20/7z920-x64.msi?r=http%3A%2F%2Fwww.7-zip.org%2Fdownload.html&ts=1301509660&use_mirror=surfnet'
$url = $url32bit
if ($is64bit) { $url = $url64bit; }

Write-Host "Downloading $fileName $systemBit to $file from $url"

#http://bartdesmet.net/blogs/bart/archive/2006/11/25/PowerShell-_2D00_-How-to-download-a-file_3F00_.aspx
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName $systemBit silently..."
msiexec /i  "$file" /quiet
write-host "$fileName $systemBit has been installed."
Start-Sleep 3