$packageName = "typescript.vs"
$installerType = "exe"
$silentArgs= "/quiet"
$url = "http://visualstudiogallery.msdn.microsoft.com/ac357f1e-9847-46ac-a4cf-520325beaec1/file/132578/1/TypeScript%20for%20Microsoft%20Visual%20Studio%202012%201.0.1.exe"

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes @(0)
