Install-ChocolateyZipPackage 'sqlite.analyzer' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
