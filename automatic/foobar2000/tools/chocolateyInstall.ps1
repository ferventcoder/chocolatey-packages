$packageName = "foobar2000"
$fileType = "exe"
$silentArgs = "/S"
$pwd = "$(split-path -parent $MyInvocation.MyCommand.Definition)"

Import-Module "$($pwd)\Get-FilenameFromRegex.ps1" -Force
# Why does an import failure on this module not throw an error?

$ErrorActionPreference = "Stop"

try {
  $url1 = Get-FilenameFromRegex "http://www.filehippo.com/download_foobar2000/history/" 'download_foobar2000/([\d]+)/"[^>]*>Foobar2000 {{PackageVersion}}<' 'http://www.filehippo.com/download_foobar2000/$1/'
} catch {
  Write-Host "Looking for alternative url"
  $latestVersion = Get-FilenameFromRegex "http://www.filehippo.com/download_foobar2000/" 'itemprop\=\"name\"\>[\s\r\n]*Foobar2000 ({{PackageVersion}})<' '$1'
  if ($latestVersion -ne '') {
    Write-Host "Attempting to find url for latest version"
    $url1 = Get-FilenameFromRegex "http://www.filehippo.com/download_foobar2000/" 'download_foobar2000/download/([\w\d]+)/[^>]*>[\s\r\n]*<span>Download Latest Version<' 'http://www.filehippo.com/en/download_foobar2000/download/$1/'
  }
}

Write-Host "Found URL that redirects to the download url: $url1"

$url2 = Get-FilenameFromRegex "$url1" 'download_foobar2000/download/([\w\d]+)/' 'http://www.filehippo.com/en/download_foobar2000/download/$1/'
Write-Host "Found secondary url that redirects to the download url: $url2"

$url3 = Get-FilenameFromRegex "$url2" '/download/file/([\w\d]+)/' 'http://www.filehippo.com/download/file/$1/'
Write-Host "Found download URL: $url3"

Install-ChocolateyPackage $packageName $fileType $silentArgs $url3

