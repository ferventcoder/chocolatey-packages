$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageName = 'webpicmd'
$installerType = 'msi'
# http://forums.iis.net/t/1178551.aspx?PLEASE+READ+WebPI+direct+download+links
$url   = 'https://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_x86_en-US.msi'
$url64 = 'https://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_amd64_en-US.msi'
$silentArgs = "/qn /norestart"

$installDir = Join-Path "$toolsDir" 'webpi'
$fileName = "$($packageName).msi"
$file = Join-Path "$toolsDir" "$fileName"

try {
  Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"

  pushd "$toolsDir"
  # the trailing backslash is required!
  &lessmsi x "$fileName" "$installDir\"
  popd

  Write-ChocolateySuccess $packageName
}
catch
{
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
}

