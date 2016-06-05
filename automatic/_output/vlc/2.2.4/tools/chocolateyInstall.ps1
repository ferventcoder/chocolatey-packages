$packageName = 'vlc'
$fileType = 'exe'
$silentArgs = '/S'
$url = 'https://get.videolan.org/vlc/2.2.4/win32/vlc-2.2.4-win32.exe'
$url64 = 'https://get.videolan.org/vlc/2.2.4/win64/vlc-2.2.4-win64.exe'

Install-ChocolateyPackage "$packageName" "$fileType" "$silentArgs" "$url" "$url64"
