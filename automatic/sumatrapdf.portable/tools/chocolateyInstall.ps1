Install-ChocolateyZipPackage 'sumatrapdf.portable' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

