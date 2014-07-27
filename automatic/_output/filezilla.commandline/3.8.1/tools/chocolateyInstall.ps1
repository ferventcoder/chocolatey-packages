$packageName = 'filezilla.commandline'
$url = 'http://download.filezilla-project.org/FileZilla_3.8.1_win32.zip'
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Rename folder, otherwise the *.exe.gui and *.exe.ignore files wouldn’t have effect
Rename-Item -Path "$unzipLocation\FileZilla" -NewName 'FileZilla-3.8.1'

Install-ChocolateyZipPackage $packageName $url $unzipLocation