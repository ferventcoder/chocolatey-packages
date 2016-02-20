$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$elaborateBytesCert = Join-Path $toolsDir 'ElaborateBytesAG_Expires2015.p7b'
try {
  & certutil.exe -addstore "TrustedPublisher" "$elaborateBytesCert"
} catch {
  Write-Warning "Cannot install certificate due to: $($_.Exception.Message). The install will continue, but it will not be silent."
  start-sleep 5
}
