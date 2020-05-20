$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/microsoft/winget-cli/releases/download/v0.1.4331-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle' # download url, HTTPS preferred
$file = Join-Path $toolsDir "$($url.Split('/')[-1])"
$checksum = 'E1B5AA89C7354DD39DB38C2AC33F0455C4529EB4CF77F023028D955122EA8377'
if((Get-WmiObject Win32_OperatingSystem).BuildNumber -lt 16299){
  throw "This package only available on Windows 10 1709 or higher"
}

Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath $file -Checksum $checksum -Url $url

if($((Get-FileHash $file).hash) -ne $checksum){
  throw "checksums don't match!"
}

Add-AppPackage -Path $file