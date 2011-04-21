try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'chrome' 'exe' '/silent' 'http://cache.pack.google.com/edgedl/chrome/install/648.204/chrome_installer.exe'
} catch {
  Start-Sleep 10
}