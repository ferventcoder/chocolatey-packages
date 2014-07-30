Function DoesWebPageExist($uri) {
    try {
        $webClient =[System.Net.HttpWebRequest] [System.Net.WebRequest]::Create($uri) ;
        $webClient.Method = "HEAD"
        $webClient.Timeout = 3000
        $webClient.GetResponse()
    } 
    catch [System.Net.WebException] {
        #$wRespStatusCode = ([System.Net.HttpWebResponse]$error[0].Exception.InnerException.Response).StatusCode.value__;
        return $false;
    }
    return $true;
}

#Todo: Check if file exists, if not , add "archive" to path and try that instead. Eg:
#http://windows.php.net/downloads/releases/archive/php-5.5.14-nts-Win32-VC11-x86.zip
#http://windows.php.net/downloads/releases/php-5.5.15-nts-Win32-VC11-x86.zip

write-host 'Please make sure you have CGI installed in IIS'
$packageName = '{{PackageName}}' 
$url = '{{DownloadUrl}}' 
$url64 = '{{DownloadUrlx64}}' 
$validExitCodes = @(0)
$targetFolder = Join-Path $(Get-BinRoot) $packageName
Install-ChocolateyZipPackage "$packageName" "$url" "$targetFolder" "$url64"
echo ("PHP installed in " + $targetFolder)
