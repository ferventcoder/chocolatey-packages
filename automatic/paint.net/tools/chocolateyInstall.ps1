$packageName = 'paint.net'
$installType = 'EXE'
$silentArgs = '/auto DESKTOPSHORTCUT=0'
$url = '{{DownloadUrl}}'

# Zipped installer
Get-ChocolateyWebFile $packageName "$ENV:Temp\chocolatey\$packageName\paint.net.install.zip" $url
Get-ChocolateyUnzip "$ENV:Temp\chocolatey\$packageName\paint.net.install.zip" "$ENV:Temp\chocolatey\$packageName"
$file = Get-ChildItem -Path "$ENV:Temp\chocolatey\$packageName\" -Recurse -Include "*.exe" | Select-Object -First 1

Install-ChocolateyInstallPackage $packageName $installType $silentArgs $file
