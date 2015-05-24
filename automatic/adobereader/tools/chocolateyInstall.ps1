$packageName = '{{PackageName}}'
$installerType = 'EXE'
$silentArgs = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
$url = '{{DownloadUrl}}'
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"
