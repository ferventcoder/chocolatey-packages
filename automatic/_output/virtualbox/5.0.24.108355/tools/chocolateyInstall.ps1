$packageName = 'virtualbox'
$tools="$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Start-ChocolateyProcessAsAdmin "certutil -addstore 'TrustedPublisher' '$tools\oracle.cer'"
Install-ChocolateyPackage $packageName 'exe' '-s -l -msiparams REBOOT=ReallySuppress' 'http://download.virtualbox.org/virtualbox/5.0.24/VirtualBox-5.0.24-108355-Win.exe'


$is64bit = (Get-WmiObject Win32_Processor).AddressWidth -eq 64
$programFiles = $env:programfiles
if ($is64bit) {$programFiles = ${env:ProgramFiles(x86)}}
$fsObject = New-Object -ComObject Scripting.FileSystemObject
$programFiles = $fsObject.GetFolder("$programFiles").ShortPath

Install-ChocolateyPath $(join-path $programFiles 'Oracle\VirtualBox')

