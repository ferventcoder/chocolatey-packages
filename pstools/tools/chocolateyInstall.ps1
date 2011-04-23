try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
	
  $scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  $fileFullPath = Get-ChocolateyWebFile 'pstools' 'zip' 'http://download.sysinternals.com/Files/PsTools.zip'
  Get-ChocolateyUnzip "$fileFullPath" $scriptPath

  write-host "PsTools Suite have been installed."
  Start-Sleep 6
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 8
	throw 
}