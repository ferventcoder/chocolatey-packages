write-host 'Please make sure you have CGI installed in IIS'
$packageName = 'php' 
$url = 'http://windows.php.net/downloads/releases/php-5.6.0-nts-Win32-VC11-x86.zip' 
$url64 = 'http://windows.php.net/downloads/releases/php-5.6.0-nts-Win32-VC11-x64.zip' 
$validExitCodes = @(0)
$targetFolder = Join-Path $(Get-BinRoot) $packageName
Install-ChocolateyZipPackage "$packageName" "$url" "$targetFolder" "$url64"
echo ("PHP installed in " + $targetFolder)