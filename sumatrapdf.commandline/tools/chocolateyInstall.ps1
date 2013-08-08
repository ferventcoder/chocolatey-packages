Install-ChocolateyZipPackage 'sumatrapdf.commandline' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
