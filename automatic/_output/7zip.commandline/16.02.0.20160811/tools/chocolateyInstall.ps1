$versionMinusDots = "16.02".Replace(".","")

$packageName = '7zip.commandline'
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$extrasDir = Join-Path "$toolsDir" "7z-extra"
$url = "http://www.7-zip.org/a/7z$($versionMinusDots).exe"
$url64 = "http://www.7-zip.org/a/7z$($versionMinusDots)-x64.exe"
$extrasUrl = "http://www.7-zip.org/a/7z$($versionMinusDots)-extra.7z"

$checksum = '629CE3C424BD884E74AED6B7D87D8F0D75274FB87143B8D6360C5EEC41D5F865'
$checksum64 = 'F1601B09CD0C9627B1AAB7299B83529E8FBC6B5078E43DFD81A1B0BFCDF4A308'
$checksumExtras = 'F6C412E8BC45E4A88E675976024C21ED7A23EEB7EB0AF452AA7A9B9A97843AA2'
$checkumType = 'sha256'



Install-ChocolateyZipPackage $packageName $url $toolsDir $url64 -checksum $checksum -checksumType $checkumType -checksum64 $checksum64 -checksumType64 $checkumType
Install-ChocolateyZipPackage $packageName $extrasUrl $extrasDir -checksum $checksumExtras -checksumType $checkumType

Remove-Item -Path "$toolsDir\Uninstall.exe"

if (Get-ProcessorBits 32) {
  # generate ignore for x64\7za.exe
  New-Item "$extrasDir\x64\7za.exe.ignore" -Type file -Force | Out-Null
} else {
  #generate ignore for 7za.exe and let x64 version pick up and shim
  New-Item "$extrasDir\7za.exe.ignore" -Type file -Force | Out-Null
}
