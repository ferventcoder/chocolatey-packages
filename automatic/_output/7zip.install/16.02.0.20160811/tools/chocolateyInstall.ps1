Function Get-ExplorerProcessCount
{
  $process = Get-Process explorer -ErrorAction SilentlyContinue
  $processCount = ($process | Measure-Object).Count
  return $processCount
}

$initialProcessCount = Get-ExplorerProcessCount
Write-Warning "This installer is known to close the explorer process. This means `nyou may lose current work. `nIf it doesn't automatically restart explorer, type 'explorer' on the `ncommand shell to restart it."

$versionMinusDots = "16.02".Replace(".","")
$packageId = '7zip.install'
$url = "http://www.7-zip.org/a/7z$($versionMinusDots).exe"
$url64 = "http://www.7-zip.org/a/7z$($versionMinusDots)-x64.exe"

$checksum = '629CE3C424BD884E74AED6B7D87D8F0D75274FB87143B8D6360C5EEC41D5F865'
$checksum64 = 'F1601B09CD0C9627B1AAB7299B83529E8FBC6B5078E43DFD81A1B0BFCDF4A308'
$checkumType = 'sha256'


Install-ChocolateyPackage $packageId 'exe' '/S' $url $url64 -checksum $checksum -checksumType $checkumType -checksum64 $checksum64 -checksumType64 $checkumType

$finalProcessCount = Get-ExplorerProcessCount
if($initialProcessCount -lt $finalProcessCount)
{
  Start-Process explorer.exe
}
