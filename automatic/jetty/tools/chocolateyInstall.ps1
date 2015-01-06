$packageName = '{{PackageName}}'
$downloadUrl = '{{DownloadUrl}}'
$downloadUrl -match "dist/(.*)\.zip"
$fileName = $matches[1]
$validExitCodes = @(0)
$installDir = Join-Path $(Get-BinRoot) $packageName
$installSubDir = Join-Path $installDir $fileName
#Install
Install-ChocolateyZipPackage "$packageName" "$downloadUrl" "$installDir"
Sleep 5 # Wait for unzip to finish...hoping 5 seconds is enough. Todo: FIX BETTER SOLUTION

# Move from subdir (e.g. jetty-v43253.543.45) in zip file to install root (jetty). This to support uninstall
mv -Force (Join-Path $installSubDir "*") $installDir
rd $installSubDir

# Report completed
write-host ($packageName + " installed to ") -NoNewLine
write-host -foregroundcolor Yellow  $installDir
