Function DoesWebPageExist($uri) {
  try {
    $webClient =[System.Net.HttpWebRequest] [System.Net.WebRequest]::Create($uri)
    $webClient.Method = "HEAD"
    $webClient.Timeout = 3000
    $webClient.GetResponse()
  }
  catch [System.Net.WebException] {
    return $FALSE;
  }
  return $TRUE;
}

Function AddArchivePathToUrl($url) {
    $newUrl = $url
	$lix = $url.LastIndexOf("/")
	if ($lix -ne -1)  {
		$newUrl = $url.SubString(0, $lix) + "/archives" + $url.SubString($lix)
	}
	return $newUrl
}

write-host 'Please make sure you have CGI installed in IIS for local hosting'
$packageName = 'php'
$url = 'http://windows.php.net/downloads/releases/php-5.6.10-nts-Win32-VC11-x86.zip'
$url64 = 'http://windows.php.net/downloads/releases/php-5.6.10-nts-Win32-VC11-x64.zip'

write-host 'Locating package …'
if (-Not (DoesWebPageExist($url))) {
	Echo ("Checking archive …")
	$url = AddArchivePathToUrl($url)
	$url64 = AddArchivePathToUrl($url64) # Assuming the 64 bit version is archived simultaneously as the 32 bit one
}

$validExitCodes = @(0)
$targetFolder = Join-Path $(Get-BinRoot) $packageName
Install-ChocolateyZipPackage "$packageName" "$url" "$targetFolder" "$url64"
Install-ChocolateyPath $targetFolder
echo ("PHP installed in " + $targetFolder)
