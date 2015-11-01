$versionMinusDots = "15.10".Replace(".","")

$packageName = '7zip.commandline'
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$installDir = Join-Path "$toolsDir" '7zip'
$fileName = "$($packageName).exe"
$file = Join-Path "$toolsDir" "$fileName"

$url = "http://www.7-zip.org/a/7z$($versionMinusDots).exe"
$url64 = "http://www.7-zip.org/a/7z$($versionMinusDots)-x64.exe"

Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"
Start-Process $file -argumentlist "/S /D=$toolsDir" -Wait

$extrasUrl = "http://www.7-zip.org/a/7z$($versionMinusDots)-extra.7z"
Install-ChocolateyZipPackage $packageName $extrasUrl $installDir

if (Get-ProcessorBits 32) {
  # generate ignore for x64\7za.exe
  New-Item "$installDir\x64\7za.exe.ignore" -Type file -Force | Out-Null
} else {
  #generate ignore for 7za.exe and let x64 version pick up and shim
  New-Item "$installDir\7za.exe.ignore" -Type file -Force | Out-Null
}
