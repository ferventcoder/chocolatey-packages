$packageName = '{{PackageName}}'

# The original \{\{DownloadUrlx64\}\} variable is “misused” as hash table
# that contains the 64-bit URL, and both MD5 checksums for 32- and 64-bit
$installerProps = {{DownloadUrlx64}}

$url = '{{DownloadUrl}}'
$checksum = $installerProps.md5sum32
$url64 = $installerProps.url64
$checksum64 = $installerProps.md5sum64

try {
  $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $installDir = Join-Path $toolsDir "ruby"


  $file = Join-Path $toolsDir "$($packageName).7z"
  Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64" -checksum "$checksum" -checksum64 "$checksum64"

  Get-ChocolateyUnzip "$file" "$installDir" -packageName "$packageName"

  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
