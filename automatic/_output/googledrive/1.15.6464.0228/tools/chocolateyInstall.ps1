Install-ChocolateyPackage 'googledrive' 'msi' '/quiet' 'https://dl.google.com/drive/1.15.6464.0228/gsync.msi' -validExitCodes @(0,3010)

# One user suggested https://dl.google.com/drive/gsync_enterprise.msi
