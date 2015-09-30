$packageName = 'paint.net'
$fileType = 'EXE'
$silentArgs = '/auto DESKTOPSHORTCUT=0'
$url = '{{DownloadUrl}}'

# Zipped installer
Get-ChocolateyWebFile $packageName "$ENV:Temp\paint.net.install.zip" $url
Get-ChocolateyUnzip "$ENV:Temp\paint.net.install.zip" "$ENV:Temp\pdn"
$installFile = Get-ChildItem -Path "$ENV:Temp\pdn" -Recurse -Include "*.exe" | Select-Object -First 1

# elevation bug
#Install-ChocolateyPackage $packageName $fileType $silentArgs $installFile
Start-Process -FilePath "$installFile" -ArgumentList "$silentArgs" -Verb Runas
