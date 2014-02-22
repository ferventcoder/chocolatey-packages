Install-ChocolateyPackage 'googledrive' 'msi' '/quiet' 'https://dl.google.com/drive/{{PackageVersion}}/gsync.msi' -validExitCodes @(0,3010)
