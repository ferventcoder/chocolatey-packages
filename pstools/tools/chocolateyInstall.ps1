try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyZipPackage 'pstools' 'http://download.sysinternals.com/Files/PsTools.zip' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 8
	throw 
}