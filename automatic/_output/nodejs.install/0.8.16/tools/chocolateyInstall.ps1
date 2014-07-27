Install-ChocolateyPackage 'nodejs.install' 'msi' '/quiet' 'http://nodejs.org/dist/v0.8.16/node-v0.8.16-x86.msi'

$nodePath = "$env:SystemDrive\Program Files\nodejs"
if (![System.IO.Directory]::Exists($nodePath)) {$nodePath = "$env:SystemDrive\Program Files (x86)\nodejs";}

$env:Path = "$($env:Path);$nodePath"