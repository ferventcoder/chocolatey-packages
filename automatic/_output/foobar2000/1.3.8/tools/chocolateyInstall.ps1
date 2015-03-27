try {

    $packageName = "foobar2000"
    $fileType = "exe"
    $silentArgs = "/S"
    $pwd = "$(split-path -parent $MyInvocation.MyCommand.Definition)"

	Import-Module "$($pwd)\Get-FilenameFromRegex.ps1"
	# Why does an import failure on this module not throw an error?

	$url1 = Get-FilenameFromRegex "http://www.filehippo.com/download_foobar2000/history/" 'download_foobar2000/([\d]+)/">Foobar2000 1.3.8<' 'http://www.filehippo.com/download_foobar2000/$1/'

    Write-Host "Found URL which contains the download URL 1: $url1"

    $url2 = Get-FilenameFromRegex "$url1" 'download_foobar2000/download/([\w\d]+)/' 'http://www.filehippo.com/en/download_foobar2000/download/$1/'
    Write-Host "Found URL which contains the download URL 2: $url2"

	$url3 = Get-FilenameFromRegex "$url2" '/download/file/([\w\d]+)/' 'http://www.filehippo.com/download/file/$1/'
	Write-Host "Found download URL: $url3"

	Install-ChocolateyPackage $packageName $fileType $silentArgs $url3

    Write-ChocolateySuccess $name
} catch {
  Write-ChocolateyFailure $name $($_.Exception.Message)
  throw
}
