try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'vlc' 'exe' '/S' 'http://downloads.sourceforge.net/project/vlc/1.1.9/win32/vlc-1.1.9-win32.exe?r=&ts=1303543605&use_mirror=ovh' 
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 10
	throw 
}