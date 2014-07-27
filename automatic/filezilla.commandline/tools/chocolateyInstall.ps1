$packageName = 'filezilla.commandline'
$url = '{{DownloadUrl}}'
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Rename folder, otherwise the *.exe.gui and *.exe.ignore files wouldn’t have effect
Rename-Item -Path "$unzipLocation\FileZilla" -NewName 'FileZilla-{{PackageVersion}}'

Install-ChocolateyZipPackage $packageName $url $unzipLocation