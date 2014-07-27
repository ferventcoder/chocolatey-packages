#Install-ChocolateyPackage 'digsby' 'exe' '/S' 'http://update.digsby.com/install/digsby_setup.exe' -validExitCodes @(0)
try {
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $installerFile = Join-Path $scriptDir 'digsby.au3'

  $tempDir = "$env:TEMP\chocolatey\digsby"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $file = Join-Path $tempDir "digsbyInstall.exe"
  Get-ChocolateyWebFile 'digsby' "$file" 'http://update.digsby.com/install/digsby_setup.exe'
  
  write-host "Installing `'$file`' with AutoIt3 using `'$installerFile`'"
  $installArgs = "/c autoit3 `"$installerFile`" `"$file`""
  Start-ChocolateyProcessAsAdmin "$installArgs" 'cmd.exe'

  Write-ChocolateySuccess 'digsby'
} catch {
  Write-ChocolateyFailure 'digsby' "$($_.Exception.Message)"
  throw 
}