Install-ChocolateyPackage '7Zip' 'msi' '/quiet' 'http://sourceforge.net/projects/sevenzip/files/7-Zip/9.22/7z922.msi' 'http://sourceforge.net/projects/sevenzip/files/7-Zip/9.22/7z922-x64.msi'

Install-ChocolateyPath  "$(join-path $env:systemdrive 'program files\7-Zip')"
