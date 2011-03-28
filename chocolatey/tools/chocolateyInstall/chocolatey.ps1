#Chocolatey's main functions

$nugetPath = 'C:\NuGet'
$nugetExePath = Join-Path $nuGetPath 'bin'
$nugetLibPath = Join-Path $nuGetPath 'lib'
$nugetChocolateyPath = Join-Path $nuGetPath 'chocolateyInstall'
$nugetExe = Join-Path $nugetChocolateyPath 'nuget.exe'

function Run-ChocolateyProcess
{
  $file, [string]$arguments = $args;
  $psi = new-object System.Diagnostics.ProcessStartInfo $file;
  $psi.Arguments = $arguments;
	#if ($elevated) {
		$psi.Verb = "runas";
	#}
  $psi.WorkingDirectory = get-location;
  $s = [System.Diagnostics.Process]::Start($psi);
	$s.WaitForExit(8000);
}

function Chocolatey-NuGet { 
param([string] $packageName)
  Write-Host 'Attempting to install ' $packageName ' to ' "$nugetLibPath"
	#something is not working right, so for now we spell out the whole path
  C:\NuGet\chocolateyInstall\NuGet.exe install $packageName /outputdirectory "$nugetLibPath"
  
  Get-ChocolateyBins $packageName
	Run-ChocolateyPS1 $packageName
}

function Get-ChocolateyBins {
param([string] $packageName)
  #search the lib directory for the highest number of the folder
  $packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "$packageName*"} | sort name -Descending | select -First 1 
  if ($packageFolder) { 
		Write-Host 'Looking for executables in folder: ' $packageFolder.FullName
		Write-Host 'Once an executable has a batch file, it will be on the PATH.'
		Write-Host 'In other words, you will be able to execute it from any command line/powershell prompt.'
		Write-Host '================================================'
		Write-Host ' Executables'
		Write-Host '================================================'
		try {
    	$files = get-childitem $packageFolder.FullName -include *.exe -recurse
    	foreach ($file in $files) {
      	Generate-BinFile $file.Name.Replace(".exe","") $file.FullName
    	}
		}
		catch {
			Write-Host 'There are no executables in the package. You may not need this as a #chocolatey #nuget. A vanilla #nuget may suffice.'
		}
		Write-Host '================================================'
  }
}

function Run-ChocolateyPS1 {
param([string] $packageName)
  $packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "$packageName*"} | sort name -Descending | select -First 1 
  if ($packageFolder) { 
		Write-Host '================================================'
		Write-Host 'Additional installation - chocolateyinstall.ps1'
		Write-Host '================================================'
		Write-Host 'Looking for chocolateyinstall.ps1 in folder: ' $packageFolder.FullName
		Write-Host 'If chocolateyInstall.ps1 is found, it will be run.'
		$ps1 = Get-ChildItem  $packageFolder.FullName -recurse | ?{$_.name -match "chocolateyinstall.ps1"} | sort name -Descending | select -First 1
		
		if ($ps1 -notlike '') {
			$ps1FullPath = $ps1.FullName
			Write-Host "Running against $ps1FullPath"
			Run-ChocolateyProcess powershell "$ps1FullPath"
		}
	}
}

function Generate-BinFile {
param([string] $name, [string] $path)
  $packageBatchFileName = Join-Path $nugetExePath "$name.bat"
	Write-Host "Adding $packageBatchFileName and pointing to $path"
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
  Write-Host 'chocolatey [install packageName|update packageName|list|help]'
  Write-Host ''
  Write-Host 'example: chocolatey install nunit'
	Write-Host 'example: chocolatey update nunit'
  Write-Host 'example: chocolatey help'
  Write-Host 'example: chocolatey list (might take awhile)'
  Write-Host '================================================'
}

function Chocolatey-List {
	#something is not working right, so for now we spell out the whole path
  C:\NuGet\chocolateyInstall\NuGet.exe list
}

$argsHasInstall = $args -contains 'install'
if ($argsHasInstall -and $args.Length -eq 2) {
 Chocolatey-NuGet  $args[1];
}

$argsHasInstall = $args -contains 'update'
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