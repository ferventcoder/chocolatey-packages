$packageName = 'nodejs.install' 
$installerType = 'msi'
$url = 'http://nodejs.org/dist/v0.10.19/node-v0.10.19-x86.msi' 
$url64 = 'http://nodejs.org/dist/v0.10.19/x64/node-v0.10.19-x64.msi' 
$silentArgs = '/quiet' 
$validExitCodes = @(0) 

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

$nodePath = "$env:SystemDrive\Program Files\nodejs"
if (![System.IO.Directory]::Exists($nodePath)) {$nodePath = "$env:SystemDrive\Program Files (x86)\nodejs";}

$env:Path = "$($env:Path);$nodePath"