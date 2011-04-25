try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
	Install-ChocolateyZipPackage 'sysinternals' 'http://download.sysinternals.com/Files/SysinternalsSuite.zip' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 8
	throw 
}