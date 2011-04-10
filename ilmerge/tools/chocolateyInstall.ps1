$fileName = 'ilmerge'
$fileType = 'msi' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {$systemBit = '64 bit';}


$url = 'http://www.microsoft.com/downloads/info.aspx?na=41&SrcFamilyId=22914587-B4AD-4EAE-87CF-B14AE6A939B0&SrcDisplayLang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f1%2f3%2f4%2f1347C99E-9DFB-4252-8F6D-A3129A069F79%2fILMerge.msi'

Write-Host "Downloading $fileName to $file from $url"

$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

#write-host "Installing $fileName silently..."
#msiexec /i  "$file" /quiet

write-host "Installing $fileName..."
msiexec /i "$file"

write-host "$fileName has been installed."
Start-Sleep 3

#------additional setup ----------------
$progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
if ($is64bit) {$progFiles = "$progFiles (x86)"}

$ilmergeFolder = Join-Path $progFiles "Microsoft\ILMerge"

$ilmergeTargetFolder = (Split-Path $MyInvocation.MyCommand.Definition)
if (![System.IO.Directory]::Exists($ilmergeTargetFolder)) {[System.IO.Directory]::CreateDirectory($ilmergeTargetFolder)}
Write-Host 'Copying the contents of ' $ilmergeFolder ' to ' $ilmergeTargetFolder '.'
Copy-Item $ilmergeFolder $ilmergeTargetFolder –recurse -force

Write-Host "Completing setup of $file."