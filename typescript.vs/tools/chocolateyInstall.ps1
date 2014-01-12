$packageName = "typescript.vs"
$installerType = "exe"
$silentArgs= "/quiet"
$url = "http://download.microsoft.com/download/2/F/F/2FFA1FBA-97CA-4FFB-8ED7-A4AE06398948/TypeScriptSetup.0.9.5.exe"

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes @(0)
