$packageName = "jetty"
$binRoot = Get-BinRoot
$installDir = Join-Path $binRoot $packageName

# Uninstall
if (!$installDir -or !(Test-Path $installDir) -or $installDir -eq "C:\") {
	Write-Host -foregroundcolor red "Installation folder not found, please uninstall manually."	
}
else {
	Echo ("Removing " + $installDir  + "...")	
	rd -Force -Recurse $installDir
}