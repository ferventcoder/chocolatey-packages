$packageName = 'nodejs'
$url = 'https://nodejs.org/dist/v5.10.0/win-x86/node.exe'
$url64 = 'https://nodejs.org/dist/v5.10.0/win-x64/node.exe'

try {
  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

  $nodePath = Join-Path $installDir 'node.exe'
  Get-ChocolateyWebFile "$packageName" "$nodePath" "$url" "$url64"

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
