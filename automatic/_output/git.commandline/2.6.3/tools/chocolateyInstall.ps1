$packageName = 'git.commandline'
$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/git-for-windows/git/releases/download/v2.6.3.windows.1/PortableGit-2.6.3-32-bit.7z.exe'
$url64 = 'https://github.com/git-for-windows/git/releases/download/v2.6.3.windows.1/PortableGit-2.6.3-64-bit.7z.exe'

Install-ChocolateyZipPackage "$packageName" "$url" "$installDir" "$url64"

$binRoot = Get-BinRoot
$gitInstallDir = Join-Path $binRoot 'git'
$deprecatedInstallDir = Join-Path $env:systemdrive 'git'


$files = get-childitem $installDir -include *.exe -recurse

foreach ($file in $files) {
  if (!($file.Name.Contains("git.exe")) -and !($file.Name.Contains("ssh"))) {
    #generate an ignore file
    New-Item "$file.ignore" -type file -force | Out-Null
  }
}

if (Test-Path $deprecatedInstallDir) { Remove-Item $deprecatedInstallDir -recurse -force -ErrorAction SilentlyContinue }
if (Test-Path $gitInstallDir) { Remove-Item $gitInstallDir -recurse -force -ErrorAction SilentlyContinue }