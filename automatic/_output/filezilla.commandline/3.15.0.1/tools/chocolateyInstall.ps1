$packageName = 'filezilla.commandline'
$url = 'http://sourceforge.net/projects/filezilla/files/FileZilla_Client/3.15.0.1/FileZilla_3.15.0.1_win32.zip/download'
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Rename folder, otherwise the *.exe.gui and *.exe.ignore files wouldn’t have effect
Rename-Item -Path "$unzipLocation\FileZilla" -NewName 'FileZilla-3.15.0.1'

Install-ChocolateyZipPackage $packageName $url $unzipLocation
