$packageName = 'sumatrapdf.commandline'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version = '{{PackageVersion}}'
$url = "https://kjkpub.s3.amazonaws.com/sumatrapdf/rel/SumatraPDF-$version.zip"
$url64 = "https://kjkpub.s3.amazonaws.com/sumatrapdf/rel/SumatraPDF-$version-64.zip"
Install-ChocolateyZipPackage $packageName $url $toolsDir $url64
