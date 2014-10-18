Install-ChocolateyZipPackage '7zip.commandline' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
