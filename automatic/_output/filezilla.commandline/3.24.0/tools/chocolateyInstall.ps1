$packageName = 'filezilla.commandline'
$url = 'https://sourceforge.net/projects/filezilla/files/FileZilla_Client/3.24.0/FileZilla_3.24.0_win32.zip/download'
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Rename folder, otherwise the *.exe.gui and *.exe.ignore files wouldn’t have effect
Rename-Item -Path "$unzipLocation\FileZilla" -NewName 'FileZilla-3.24.0'

Install-ChocolateyZipPackage $packageName $url $unzipLocation
