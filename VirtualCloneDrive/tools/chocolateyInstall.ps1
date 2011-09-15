try {
  $toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
  $elaborateBytesCert = Join-Path $toolsDir 'ElaborateBytesAG.cer'
  try {
    & certutil.exe -addstore "TrustedPublisher" "$elaborateBytesCert"
  } catch {
    write-host "Cannot install certificate due to: $($_.Exception.Message). The install will continue, but it will not be silent."
    start-sleep 5
  }
  
  Install-ChocolateyPackage 'VirtualCloneDrive' 'exe' '/S /noreboot' 'http://static.slysoft.com/SetupVirtualCloneDrive.exe'

  Write-ChocolateySuccess 'VirtualCloneDrive'
} catch {
  Write-ChocolateyFailure 'VirtualCloneDrive' "$($_.Exception.Message)"
  throw 
}