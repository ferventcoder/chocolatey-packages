try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'mono' 'exe' '/SILENT' 'http://ftp.novell.com/pub/mono/archive/2.10.1/windows-installer/2/mono-2.10.1-gtksharp-2.12.10-win32-2.exe' 
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 5
	throw 
}