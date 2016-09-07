$packageName = "foobar2000"
$installerType = "exe"
$silentArgs = "/S"
$version = '{{PackageVersion}}'
$tempURL = (((invoke-webrequest -uri "https://foobar2000.org/download" -usebasicparsing).Links.Href | Select-String -Pattern .*foobar2000_v${version}.exe).Line).Replace("getfile","files")
$url = "https://foobar2000.org$tempURL"

Install-ChocolateyPackage $packageName $installerType $silentArgs $url

