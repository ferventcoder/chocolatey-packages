Install-ChocolateyZipPackage 'sqlite.shell' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
