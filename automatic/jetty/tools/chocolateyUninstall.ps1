#Common for install and uninstall:
$packageName = "jetty"
$fileName = "jetty-distribution-9.1.4.v20140401"
$downloadUrl = ("http://mirror.netcologne.de/eclipse/jetty/stable-9/dist/" + $fileName + ".zip")
$binRoot = Get-BinRoot
$installDir = Join-Path $binRoot $packageName
$installSubDir = Join-Path $installDir $fileName

# Uninstall
if (!$installDir -or !(Test-Path $installDir) -or $installDir -eq "C:\") {
	Write-Host -foregroundcolor red "Installation folder not found, please uninstall manually."	
}
else {
	Echo ("Removing " + $installDir  + "...")	
	rd -Force -Recurse $installDir
}