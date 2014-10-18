Install-ChocolateyZipPackage '7zip.portable' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
