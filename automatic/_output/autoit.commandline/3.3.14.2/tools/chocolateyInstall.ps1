$packageName = 'autoit.commandline'
$url = 'http://www.autoitscript.com/files/autoit3/autoit-v3.zip'
$unzipLocation = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

try {
    Install-ChocolateyZipPackage $packageName $url $unzipLocation
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
