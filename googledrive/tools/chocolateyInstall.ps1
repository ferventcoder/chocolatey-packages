Install-ChocolateyPackage 'googledrive' 'msi' '/quiet' '{{DownloadUrl}}' -validExitCodes @(0,3010)
