$packageName = 'nodejs.install'
$installerType = 'msi'
$url = 'https://nodejs.org/dist/v6.10.1/node-v6.10.1-x86.msi'
$url64 = 'https://nodejs.org/dist/v6.10.1/node-v6.10.1-x64.msi'
$silentArgs = '/quiet'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

$nodePath = "$env:SystemDrive\Program Files\nodejs"
if (![System.IO.Directory]::Exists($nodePath)) {$nodePath = "$env:SystemDrive\Program Files (x86)\nodejs";}

$env:Path = "$($env:Path);$nodePath"
