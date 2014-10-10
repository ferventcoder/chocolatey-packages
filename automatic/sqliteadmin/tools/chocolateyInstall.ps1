Install-ChocolateyZipPackage 'sqliteadmin' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
