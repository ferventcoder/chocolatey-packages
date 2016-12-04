﻿$packageId = 'miranda'
$fileType = 'exe'
$fileArgs = '/S'

# If you see \{\{DownloadUrlx64\}\} (without backslashes) in the source code,
# it’s intentional.
$url = 'https://sourceforge.net/projects/miranda/files/miranda-im/0.10.63.0/miranda-im-v0.10.63-unicode.exe'

Install-ChocolateyPackage $packageId $fileType $fileArgs $url -validExitCodes @(0)
