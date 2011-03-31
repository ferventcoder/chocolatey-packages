$fileName = 'vlc'
$fileType = 'exe'

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$url = 'http://downloads.sourceforge.net/project/vlc/1.1.8/win32/vlc-1.1.8-win32.exe?r=http%3A%2F%2Fwww.01net.com%2Ftelecharger%2Fwindows%2FMultimedia%2Flecteurs_video_dvd%2Ffiches%2F23823.html&ts=1301516975&use_mirror=freefr'

Write-Host "Downloading $fileName to $file from $url"
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName silently..."
if ($fileType -like 'msi') {
  msiexec /i  "$file" /quiet
}
if ($fileType -like 'exe') {
& "$file" "/S" #"/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer
}

write-host "$fileName has been installed."
Start-Sleep 3