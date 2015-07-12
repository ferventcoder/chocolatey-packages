$packageName = '7zip.commandline'
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$installDir = Join-Path "$toolsDir" '7zip'
$fileName = "$($packageName).msi"
$file = Join-Path "$toolsDir" "$fileName"

$url = 'http://www.7-zip.org/a/7z938.msi'
$url64 = 'http://www.7-zip.org/a/7z938-x64.msi'

Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"

Update-SessionEnvironment

pushd "$toolsDir"
# the trailing backslash is required!
&lessmsi x "$fileName" "$installDir\"
popd

$extrasUrl = "http://www.7-zip.org/a/7z938-extra.7z"
Install-ChocolateyZipPackage $packageId $extrasUrl $installDir

if (Get-ProcessorBits 32) {
  # generate ignore for x64\7za.exe
  New-Item "$installDir\x64\7za.exe.ignore" -Type file -Force | Out-Null
} else {
  #generate ignore for 7za.exe and let x64 version pick up and shim
  New-Item "$installDir\7za.exe.ignore" -Type file -Force | Out-Null
}
