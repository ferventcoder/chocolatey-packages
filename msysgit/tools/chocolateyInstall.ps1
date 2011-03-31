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
& "$file" "/SILENT" #"/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer
}

write-host "$fileName has been installed."
Start-Sleep 3

#get the PATH variable from the machine
$envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

$gitPath = '\Git\cmd'
#if you do not find C:\Program Files (x86)\Git\cmd, add it 
if (!$envPath.ToLower().Contains($nugetExePath.ToLower()))
{
  Write-Host ''
  #now we update the path
  Write-Host 'PATH environment variable does not have ' $nugetExePath ' in it. Adding.'

  #does the path end in ';'?
  $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
  # if the last digit is not ;, then we are adding it
  If (!$hasStatementTerminator) {$nugetExePath = $statementTerminator + $nugetExePath}
  $envPath = $envPath + $nugetExePath + $statementTerminator

  #[Environment]::SetEnvironmentVariable( "Path", $envPath, [System.EnvironmentVariableTarget]::Machine )
  [Environment]::SetEnvironmentVariable( 'Path', '" + $envPath + "', [System.EnvironmentVariableTarget]::Machine )  #-executionPolicy Unrestricted"

@"

Adding git commands to the PATH
"@ | Write-Host


  #add it to the local path as well so users will be off and running
  $envPSPath = $env:PATH
  $env:Path = $envPSPath + $statementTerminator + $nugetExePath + $statementTerminator
}