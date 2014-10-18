try {
  $installDIr = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir)}

  $tempDir = "$env:TEMP\chocolatey\maxthon.portable"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

  $file = Join-Path $tempDir "maxthon.portable.7z"
  Get-ChocolateyWebFile 'maxthon.portable' "$file" '{{DownloadUrl}}'

  Start-Process "7za" -ArgumentList "x -o`"$installDir`" -y `"$file`"" -Wait

  Write-ChocolateySuccess 'maxthon.portable'
} catch {
  Write-ChocolateyFailure 'maxthon.portable' "$($_.Exception.Message)"
  throw
}
