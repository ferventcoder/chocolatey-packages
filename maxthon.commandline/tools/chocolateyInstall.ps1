try { 
  $installDIr = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir)}
  
  $tempDir = "$env:TEMP\chocolatey\maxthon.commandline"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

  $file = Join-Path $tempDir "maxthon.commandline.7z"
  Get-ChocolateyWebFile 'maxthon.commandline' "$file" '{{DownloadUrl}}'

  Start-Process "7za" -ArgumentList "x -o`"$installDir`" -y `"$file`"" -Wait
  
  Write-ChocolateySuccess 'maxthon.commandline'
} catch {
  Write-ChocolateyFailure 'maxthon.commandline' "$($_.Exception.Message)"
  throw 
}