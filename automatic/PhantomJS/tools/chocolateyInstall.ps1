$package = '{{PackageName}}'
$version = '{{PackageVersion}}'
$zipUrl = '{{DownloadUrl}}'
$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage $package "$zipUrl" "$installDir"
