$fileName = 'aspnetmvc'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$url = 'http://www.microsoft.com/downloads/info.aspx?na=46&SrcFamilyId=C9BA1FE1-3BA8-439A-9E21-DEF90A8615A9&SrcDisplayLang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f7%2fB%2f1%2f7B11DE4E-0247-448E-8D39-7C9B12ABA1FF%2fAspNetMVC2_VS2008.exe'

Write-Host "Downloading $fileName to $file from $url"

$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName..."
Start-Process -FilePath $file -Wait

write-host "$fileName has been installed."
Start-Sleep 3