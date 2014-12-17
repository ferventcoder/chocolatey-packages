Install-ChocolateyZipPackage 'notepadplusplus.portable' '{{DownloadUrl}}' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
