write-host 'Please make sure you have CGI installed in IIS'
$packageName = '{{PackageName}}' 
$validExitCodes = @(0)
$targetFolder = Join-Path $(Get-BinRoot) $packageName
Echo ("Deleting" + $targetFolder)
Remove-Item -Force -Recurse $targetFolder