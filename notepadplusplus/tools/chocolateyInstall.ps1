try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'notepadplusplus' 'exe' '/S' 'http://download.tuxfamily.org/notepadplus/5.8.7/npp.5.8.7.Installer.exe'
} catch {
  Start-Sleep 10
}