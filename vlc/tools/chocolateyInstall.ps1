try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'vlc' 'exe' '/S' 'http://downloads.sourceforge.net/project/vlc/1.1.8/win32/vlc-1.1.8-win32.exe?r=http%3A%2F%2Fwww.01net.com%2Ftelecharger%2Fwindows%2FMultimedia%2Flecteurs_video_dvd%2Ffiches%2F23823.html&ts=1301516975&use_mirror=freefr' 
} catch {
  Start-Sleep 10
}