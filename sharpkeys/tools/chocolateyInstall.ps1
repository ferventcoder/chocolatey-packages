try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'sharpkeys' 'msi' '/S' 'http://www.randyrants.com/sharpkeys3.msi'
} catch {
  Start-Sleep 10
}