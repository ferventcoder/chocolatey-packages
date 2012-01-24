$packageName = 'vim'
$fileType = 'exe'
$silentArgs = '/S'
$url = 'http://downloads.sourceforge.net/project/cream/Vim/7.3.401/gvim-7-3-401.exe'

Install-ChocolateyPackage $packageName $fileType $silentArgs $url
