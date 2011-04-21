try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'lockhunter' 'exe' '/SILENT' 'http://lockhunter.com/lockhuntersetup32.exe' 'http://lockhunter.com/lockhuntersetup64.exe' 
} catch {
  Start-Sleep 10
}