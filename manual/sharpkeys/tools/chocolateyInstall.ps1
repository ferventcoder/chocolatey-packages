$packageName = 'sharpkeys'
$packageType = 'msi'
$silentArgs = '/qn'
$url = 'https://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=sharpkeys&DownloadId=319724&FileTime=129737577110830000&Build=20911'

Install-ChocolateyPackage "$packageName" "$packageType" "$silentArgs" "$url"

