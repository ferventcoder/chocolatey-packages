$fileName = 'aspnetmvc'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$url = 'http://www.microsoft.com/downloads/info.aspx?na=46&SrcFamilyId=D2928BC1-F48C-4E95-A064-2A455A22C8F6&SrcDisplayLang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f3%2f4%2fA%2f34A8A203-BD4B-44A2-AF8B-CA2CFCB311CC%2fAspNetMVC3Setup.exe'

Write-Host "Downloading $fileName to $file from $url"

$downloader = new-object System.Net.WebClient
#$downloader.DownloadFile($url, $file)

write-host "Installing $fileName..."
Start-Process -FilePath $file -Wait #-ArgumentList "/q"

write-host "$fileName has been installed."
Start-Sleep 3