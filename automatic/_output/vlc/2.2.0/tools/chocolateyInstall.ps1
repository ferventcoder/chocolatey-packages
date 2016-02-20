$packageName = 'vlc'
$fileType = 'exe'
$silentArgs = '/S'
$url = 'http://download.videolan.org/pub/videolan/vlc/2.2.0/win32/vlc-2.2.0-win32.exe'
$url64 = 'http://download.videolan.org/pub/videolan/vlc/2.2.0/win64/vlc-2.2.0-win64.exe'

Install-ChocolateyPackage "$packageName" "$fileType" "$silentArgs" "$url" "$url64"
