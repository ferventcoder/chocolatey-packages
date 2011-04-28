try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  
  Install-ChocolateyPackage 'resharper' 'msi' '/quiet' 'http://download.jetbrains.com/resharper/ReSharperSetup.5.1.3000.12.msi' 
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 8
	throw 
}