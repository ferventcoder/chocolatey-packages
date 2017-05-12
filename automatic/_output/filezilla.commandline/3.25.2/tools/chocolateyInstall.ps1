$packageName = 'filezilla.commandline'
$url = 'https://sourceforge.net/projects/filezilla/files/FileZilla_Client/3.25.2/FileZilla_3.25.2_win32.zip/download'
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Rename folder, otherwise the *.exe.gui and *.exe.ignore files wouldn’t have effect
Rename-Item -Path "$unzipLocation\FileZilla" -NewName 'FileZilla-3.25.2'

Install-ChocolateyZipPackage $packageName $url $unzipLocation
