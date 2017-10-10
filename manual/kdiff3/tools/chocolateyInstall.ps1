$arguments = @{
  PackageName = 'kdiff3'
  FileType = 'exe'
  SilentArgs = '/S'
  Url = 'https://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.98/KDiff3-32bit-Setup_0.9.98-3.exe'
  Url64 = 'https://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.98/KDiff3-64bit-Setup_0.9.98-2.exe'
  Checksum = '3DCDE7057D2D527A567EA674F6693E250D0C273F981A3CFB513FBDCFF9E6614B'
  Checksum64 = 'D630AB0FDCA3B4F1A85AB7E453F669FDC901CB81BB57F7E20DE64C02AC9A1EEB'
  ChecksumType = 'SHA256'
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @arguments

#------additional setup ----------------
#add it to the path
$programPath = "$env:SystemDrive\Program Files\kdiff3"
if (![System.IO.Directory]::Exists($programPath)) {
$programPath = "$env:SystemDrive\Program Files (x86)\kdiff3";
}
Install-ChocolateyPath $programPath
