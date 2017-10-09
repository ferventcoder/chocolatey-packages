$packageName = 'kdiff3'
$fileType = 'exe'
$silentArgs = '/S'
$url = 'https://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.98/KDiff3-32bit-Setup_0.9.98-3.exe'
$url64 = 'https://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.98/KDiff3-64bit-Setup_0.9.98-2.exe'

Install-ChocolateyPackage $packageName $fileType $silentArgs $url $url64 -validExitCodes @(0)

#------additional setup ----------------
#add it to the path
$programPath = "$env:SystemDrive\Program Files\kdiff3"
if (![System.IO.Directory]::Exists($programPath)) {
$programPath = "$env:SystemDrive\Program Files (x86)\kdiff3";
}
Install-ChocolateyPath $programPath
