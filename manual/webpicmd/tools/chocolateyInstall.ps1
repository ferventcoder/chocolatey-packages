$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageName = 'webpicmd'
$installerType = 'msi'
# http://forums.iis.net/t/1178551.aspx?PLEASE+READ+WebPI+direct+download+links
$url   = 'https://go.microsoft.com/fwlink/?LinkId=287165'
$url64 = 'https://go.microsoft.com/fwlink/?LinkId=287166'
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

