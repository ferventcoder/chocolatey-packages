try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage '7Zip' 'msi' '/quiet' 'http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.20/7z920.msi?r=&ts=1301509610&use_mirror=iweb' 'http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.20/7z920-x64.msi?r=http%3A%2F%2Fwww.7-zip.org%2Fdownload.html&ts=1301509660&use_mirror=surfnet' 
} catch {
  Start-Sleep 10
}