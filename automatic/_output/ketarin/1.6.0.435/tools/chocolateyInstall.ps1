$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 
Install-ChocolateyZipPackage 'ketarin' 'http://ketarin.org/download' $toolsDir 
$guiFile = Join-Path $toolsDir Ketarin.exe.gui
echo ''> $guiFile