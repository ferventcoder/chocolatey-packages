try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'ruby' 'exe' "/silent /tasks=`"assocfiles,modpath`"" 'http://rubyforge.org/frs/download.php/74298/rubyinstaller-1.9.2-p180.exe'
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 5
	throw 
}