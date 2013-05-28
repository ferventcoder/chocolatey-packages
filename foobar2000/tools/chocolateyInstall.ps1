try {

    $packageName = "foobar2000"
    $fileType = "exe"
    $silentArgs = "/S"
    $pwd = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
    
	Import-Module "$($pwd)\Get-FilenameFromRegex.ps1"
	# Why does an import failure on this module not throw an error?

    $url1 = Get-FilenameFromRegex "http://www.filehippo.com/download_foobar2000/" 'download_foobar2000/download/([\w\d]+)/' 'http://www.filehippo.com/de/download_foobar2000/download/$1/'
    Write-Host "Found URL which contains the download URL: $url1"

	$url2 = Get-FilenameFromRegex "$url1" '/download/file/([\w\d]+)/' 'http://www.filehippo.com/download/file/$1/'
	Write-Host "Found download URL: $url2"

	Install-ChocolateyPackage $packageName $fileType $silentArgs $url2

    Write-ChocolateySuccess $name
} catch {
  Write-ChocolateyFailure $name $($_.Exception.Message)
  throw
}