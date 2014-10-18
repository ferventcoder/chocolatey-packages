Install-ChocolateyZipPackage '{{PackageName}}' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" '{{DownloadUrlx64}}'
