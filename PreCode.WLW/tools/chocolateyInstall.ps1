$packageName = 'PreCode.WLW'
$installerType = 'msi'
$url = 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=precode&DownloadId=109787&FileTime=129124319499800000&Build=19748'
$url64 = $url 
$silentArgs = '/quiet'
$validExitCodes = @(0) 

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
