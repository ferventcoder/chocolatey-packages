$packageName = '{{PackageName}}' 
$downloadUrl = '{{DownloadUrl}}' 
$downloadUrl -match "dist/(.*)\.zip"
$fileName = $matches[1]
$validExitCodes = @(0)
$installDir = Join-Path $(Get-BinRoot) $packageName
$installSubDir = Join-Path $installDir $fileName

echo ("Package name: " + $packageName)
echo ("Download URL: " + $downloadUrl)
echo ("Install folder: " + $fileName)
echo ("Folder name: " + $fileName)

#Install
Install-ChocolateyZipPackage "$packageName" "$downloadUrl" "$installDir"

# Move from subdir (e.g. jetty-v43253.543.45) in zip file to install root (jetty)
mv (Join-Path $installSubDir "*") $installDir
rd $installSubDir

# Report completed
write-host ($packageName + " installed to ") -NoNewLine
write-host -foregroundcolor Yellow  $installDir
