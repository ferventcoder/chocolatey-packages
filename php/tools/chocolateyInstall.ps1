write-host 'Please make sure you have CGI installed in IIS'
$packageName = '{{PackageName}}' 
$url = '{{DownloadUrl}}' 
$url64 = '{{DownloadUrlx64}}' 
$validExitCodes = @(0)
$targetFolder = Join-Path $(Get-BinRoot) $packageName
Install-ChocolateyZipPackage "$packageName" "$url" "$targetFolder" "$url64"
echo ("PHP installed in " + $targetFolder)