$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageName = 'webpicmd'
$installerType = 'msi'
$url   = 'http://download.microsoft.com/download/7/0/4/704CEB4C-9F42-4962-A2B0-5C84B0682C7A/WebPlatformInstaller_x86_en-US.msi'
$url64 = 'http://download.microsoft.com/download/7/0/4/704CEB4C-9F42-4962-A2B0-5C84B0682C7A/WebPlatformInstaller_amd64_en-US.msi'
$silentArgs = "/passive /norestart"

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
