$packageName = 'jetty'
$downloadUrl = 'http://mirror.netcologne.de/eclipse/jetty/stable-9/dist/jetty-distribution-9.3.6.v20151106.zip'
$downloadUrl -match "dist/(.*)\.zip"
$fileName = $matches[1]
$validExitCodes = @(0)
$installDir = Join-Path $(Get-BinRoot) $packageName
$installSubDir = Join-Path $installDir $fileName
#Install
Install-ChocolateyZipPackage "$packageName" "$downloadUrl" "$installDir"

# Move from subdir (e.g. jetty-v43253.543.45) in zip file to install root (jetty). This to support uninstall
mv -Force (Join-Path $installSubDir "*") $installDir
rd $installSubDir

# Report completed
write-host ($packageName + " installed to ") -NoNewLine
write-host -foregroundcolor Yellow  $installDir
