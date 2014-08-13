Install-ChocolateyPackage 'googledrive' 'msi' '/quiet' 'https://dl.google.com/drive/1.17.7290.4094/gsync.msi' -validExitCodes @(0,3010)

# One user suggested https://dl.google.com/drive/gsync_enterprise.msi
