$package = 'nmap'
$file = (Get-ItemProperty HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Nmap UninstallString).UninstallString;
Uninstall-ChocolateyPackage $package 'EXE' -SilentArgs '/S' -file $file
