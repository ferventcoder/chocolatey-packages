$fileName = 'msysgit'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {$systemBit = '64 bit';}

$url = 'http://msysgit.googlecode.com/files/Git-1.7.3.1-preview20101002.exe'

Write-Host "Downloading $fileName to $file from $url"

$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

write-host "Installing $fileName silently..."
if ($fileType -like 'msi') {
  msiexec /i  "$file" /quiet
}
if ($fileType -like 'exe') {
  #& "$file" "/SILENT" #"/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer
  Start-Process -FilePath $file -ArgumentList "/SILENT" -Wait
}

write-host "$fileName has been installed."

#------additional setup ----------------
#get the PATH variable from the machine
$envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

$progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
if ($is64bit) {$progFiles = "$progFiles (x86)"}

$gitPath = Join-Path $progFiles 'Git\cmd'
#if you do not find C:\Program Files (x86)\Git\cmd, add it 
if (!$envPath.ToLower().Contains($gitPath.ToLower()))
{
  Write-Host ''
  #now we update the path
  Write-Host 'PATH environment variable does not have ' $gitPath ' in it. Adding.'

  #does the path end in ';'?
  $statementTerminator = ';'
  $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
  # if the last digit is not ;, then we are adding it
  If (!$hasStatementTerminator) {$gitPath = $statementTerminator + $gitPath}
  $envPath = $envPath + $gitPath + $statementTerminator

  [Environment]::SetEnvironmentVariable( "Path", $envPath, [System.EnvironmentVariableTarget]::Machine )

@"

Adding git commands to the PATH
"@ | Write-Host


  #add it to the local path as well so users will be off and running
  $envPSPath = $env:PATH
  $env:Path = $envPSPath + $statementTerminator + $gitPath + $statementTerminator
}

@"

Making GIT core.autocrlf false
"@ | Write-Host

#make GIT core.autocrlf false
& 'cmd.exe' '/c git config --global core.autocrlf false'

Write-Host "Finished all setup of $fileName"
Start-Sleep 4