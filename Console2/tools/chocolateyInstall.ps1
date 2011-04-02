$fileName = 'Console2'
$fileType = 'exe' #msi or exe

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$fileName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "$fileName.$fileType"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$systemBit = '32 bit'
if ($is64bit) {$systemBit = '64 bit';}

$url = 'http://sourceforge.net/projects/console/'

$mydir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$contentSettingsFile = ($mydir | Split-Path | Join-Path -ChildPath "content" | Join-Path -ChildPath "console.xml")
$binSettingsFile = ($mydir | Split-Path | Join-Path -ChildPath "bin" | Join-Path -ChildPath "console.xml")

if(!(test-path $binSettingsFile)) {
    Write-Host "Creating default settings file from $contentSettingsFile"
    copy-item $contentSettingsFile $binSettingsFile
}

write-host "$fileName has been installed."
Start-Sleep 3