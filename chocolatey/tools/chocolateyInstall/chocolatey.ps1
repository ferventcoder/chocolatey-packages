#Chocolatey's main functions

$nugetPath = 'C:\NuGet'
$nugetExePath = Join-Path $nuGetPath 'bin'
$nugetLibPath = Join-Path $nuGetPath 'lib'
$nugetChocolateyPath = Join-Path $nuGetPath 'chocolateyInstall'
$nugetExe = Join-Path $nugetChocolateyPath 'nuget.exe'

function Chocolatey-NuGet { 
param([string] $packageName)
  Write-Host Attempting to install $packageName to "$nugetLibPath"
	#something is not working right, so for now we spell out the whole path
  C:\NuGet\chocolateyInstall\NuGet.exe install $packageName /outputdirectory "$nugetLibPath"
  
  Get-ChocolateyBins $packageName
}

function Get-ChocolateyBins {
param([string] $packageName)
  #search the lib directory for the highest number of the folder
  $packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "$packageName*"} | sort name -Descending | select -First 1 
  if ($packageFolder) { 
    $files = get-childitem $packageFolder.FullName -include *.exe -recurse
    foreach ($file in $files) {
      Generate-BinFile $file.Name.Replace(".exe","") $file.FullName
    }
  }
}

function Generate-BinFile {
param([string] $name, [string] $path)
  $packageBatchFileName = Join-Path $nugetExePath "$name.bat"
"@echo off
""$path"" %*" | Out-File $packageBatchFileName -encoding ASCII 
}

function Chocolatey-Help {
  Write-Host '================================================'
  Write-Host 'Chocolatey - Your local machine NuGet Repository'
  Write-Host '================================================'
  Write-Host 'Chocolatey allows you to install application nuggets and run executables from anywhere.'
  Write-Host ''
  Write-Host '====='
  Write-Host 'Usage'
  Write-Host '====='
  Write-Host 'chocolatey [[install] packageName|list|help]'
  Write-Host ''
  Write-Host 'example: chocolatey install nunit'
  Write-Host 'example: chocolatey help'
  Write-Host 'example: chocolatey list (might take awhile)'
  Write-Host '================================================'
}

function Chocolatey-List {
	#something is not working right, so for now we spell out the whole path
  C:\NuGet\chocolateyInstall\NuGet.exe list
}

#default is to install
if ($args.Length -eq 1 -and $args[0] -notcontains 'list' -and $args[0] -notcontains 'help') {
 Chocolatey-NuGet  $args[0];
}
$argsHasInstall = $args -contains 'install'
if ($argsHasInstall -and $args.Length -eq 2) {
 Chocolatey-NuGet  $args[1];
}

$argsHasList = $args -contains 'list'
if ($argsHasList) {
  Chocolatey-List
}

$argsHasHelp = $args -contains 'help'
if ($argsHasHelp) {
  Chocolatey-Help
}
if ($args.Length -eq 0) {
	Chocolatey-Help
}