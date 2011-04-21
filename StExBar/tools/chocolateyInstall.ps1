try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'StExBar' 'msi' '/quiet' 'http://stexbar.googlecode.com/files/StExBar-1.8.2.msi' 'http://stexbar.googlecode.com/files/StExBar64-1.8.2.msi' 
} catch {
  Start-Sleep 10
}