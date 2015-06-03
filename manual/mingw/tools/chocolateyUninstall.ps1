. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) chocolateyInclude.ps1)

Uninstall-ChocolateyZipPackage "$packageName" "${packageName}Install.zip"
