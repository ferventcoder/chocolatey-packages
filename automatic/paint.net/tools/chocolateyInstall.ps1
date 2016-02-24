﻿$packageName = 'paint.net'
$url = '{{DownloadUrl}}'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$installerType = 'exe'
$silentArgs = '/auto DESKTOPSHORTCUT=0'

Install-ChocolateyZipPackage $packageName $url $toolsDir
$paintFileFullPath = Get-ChildItem $toolsDir -Recurse -Include *.exe | Select -First 1
Install-ChocolateyInstallPackage $packageName $installerType $silentArgs $paintFileFullPath
Remove-Item $paintFileFullPath
