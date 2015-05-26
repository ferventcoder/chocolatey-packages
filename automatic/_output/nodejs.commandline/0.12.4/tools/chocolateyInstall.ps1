$packageName = 'nodejs'
$url = 'http://nodejs.org/dist/v0.12.4/node.exe'
$url64 = 'http://nodejs.org/dist/v0.12.4/x64/node.exe'

try {
  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

  $nodePath = Join-Path $installDir 'node.exe'
  Get-ChocolateyWebFile "$packageName" "$nodePath" "$url" "$url64"

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
