$packageName = 'filezilla.commandline'
$url = 'http://iweb.dl.sourceforge.net/project/filezilla/FileZilla_Client/3.7.4/FileZilla_3.7.4_win32.zip'
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Rename folder, otherwise the *.exe.gui and *.exe.ignore files wouldn’t have effect
Rename-Item -Path "$unzipLocation\FileZilla" -NewName 'FileZilla-3.7.4'

Install-ChocolateyZipPackage $packageName $url $unzipLocation