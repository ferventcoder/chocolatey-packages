Install-ChocolateyPackage 'nodejs.install' 'msi' '/quiet' '{{DownloadUrl}}'

$nodePath = "$env:SystemDrive\Program Files\nodejs"
if (![System.IO.Directory]::Exists($nodePath)) {$nodePath = "$env:SystemDrive\Program Files (x86)\nodejs";}

$env:Path = "$($env:Path);$nodePath"