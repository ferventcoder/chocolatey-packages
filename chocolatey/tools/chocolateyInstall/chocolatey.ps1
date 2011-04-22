param($command,$packageName='',$source='https://go.microsoft.com/fwlink/?LinkID=206669',$version='')#todo:,[switch] $silent)

#Chocolatey
$chocVer = '0.9.6.0'
$nugetPath = 'C:\NuGet'
$nugetExePath = Join-Path $nuGetPath 'bin'
$nugetLibPath = Join-Path $nuGetPath 'lib'
$nugetChocolateyPath = Join-Path $nuGetPath 'chocolateyInstall'
$nugetExe = Join-Path $nugetChocolateyPath 'nuget.exe'
$h1 = '====================================================='
$h2 = '-------------------------'

function Run-ChocolateyProcess {
param([string]$file, [string]$arguments = $args, [switch] $elevated);
	
	Write-Host "Elevating Permissions and running $file $args. This may take awhile, depending on the package.";
  $psi = new-object System.Diagnostics.ProcessStartInfo $file;
  $psi.Arguments = $arguments;
 	Write-Host "Elevating Permissions";
	$psi.Verb = "runas";
  $psi.WorkingDirectory = get-location;
 
  $s = [System.Diagnostics.Process]::Start($psi);
  $s.WaitForExit(300000);

}

function Chocolatey-NuGet { 
param([string] $packageName, $source = 'https://go.microsoft.com/fwlink/?LinkID=206669')

@"
$h1
Chocolatey ($chocVer) is installing $packageName (from $source) to "$nugetLibPath"
$h1
Package License Acceptance Terms
$h2
Please run chocolatey /? for full license acceptance verbage. By installing you accept the license for the package you are installing...
$h2
"@ | Write-Host

	$nugetOutput = Run-NuGet $packageName $source $version
	
	foreach ($line in $nugetOutput) {
		if ($line -notlike "*not installed*") {
			$installedPackageName = ''
			$installedPackageVersion = ''
		
			$regex = [regex]"'[.\S]+\s?"
	    $pkgNameMatches = $regex.Matches($line) | select -First 1 
			if ($pkgNameMatches -ne $null) {
				$installedPackageName = $pkgNameMatches -replace "'", "" -replace " ", ""
			}
			
			$regex = [regex]"[0-9.]+[[)]?'"
			$pkgVersionMatches = $regex.Matches($line) | select -First 1 
			if ($pkgVersionMatches -ne $null) {
				$installedPackageVersion = $pkgVersionMatches -replace '\)', '' -replace "'", "" -replace " ", ""
			}
			
			if ($installedPackageName -ne '' -and $installedPackageVersion -ne '') {
				#search the lib directory for the highest number of the folder
				#$packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "^$packageName*"} | sort name -Descending | select -First 1 
				$packageFolder = Join-Path $nugetLibPath "$($installedPackageName).$($installedPackageVersion)" 
@"
$h2
$h2
Chocolatey Runner ($($installedPackageName.ToUpper()))
$h2
"@ | Write-Host

				if ([System.IO.Directory]::Exists($packageFolder)) {
					Run-ChocolateyPS1 $packageFolder
	    		Get-ChocolateyBins $packageFolder
				}
			}
  	}	
	}
  
@"
$h1
Chocolatey has finished installing $packageName
$h1
"@ | Write-Host
}

function Run-NuGet {
param([string] $packageName, $source = 'https://go.microsoft.com/fwlink/?LinkID=206669',$version = '')
@"
$h2
NuGet
$h2
"@ | Write-Host

	#todo: If package name is non-existent or is set to all, it means we are going to update all currently installed packages.
  $packageArgs = "install $packageName /outputdirectory `"$nugetLibPath`" /source $source"
  if ($version -notlike '') {
    $packageArgs = $packageArgs + " /version $version";
  }
  $logFile = Join-Path $nugetChocolateyPath 'install.log'
	$errorLogFile = Join-Path $nugetChocolateyPath 'error.log'
  Start-Process $nugetExe -ArgumentList $packageArgs -NoNewWindow -Wait -RedirectStandardOutput $logFile -RedirectStandardError $errorLogFile
	
  $nugetOutput = Get-Content $logFile -Encoding Ascii
	foreach ($line in $nugetOutput) {
    Write-Host $line
  }
	$errors = Get-Content $errorLogFile
	if ($errors -ne '') {
		Write-Host $errors -BackgroundColor Red -ForegroundColor White
		#throw (Get-Content $errorLogFile);
	}
	
	return $nugetOutput
}

function Run-ChocolateyPS1 {
param([string] $packageFolder)
  if ($packageFolder -notlike '') { 
@"
$h2
Chocolatey Installation (chocolateyinstall.ps1)
$h2
Looking for chocolateyinstall.ps1 in folder $packageFolder
If chocolateyInstall.ps1 is found, it will be run.
$h2
"@ | Write-Host

    $ps1 = Get-ChildItem  $packageFolder -recurse | ?{$_.name -match "chocolateyinstall.ps1"} | sort name -Descending | select -First 1
    
    if ($ps1 -notlike '') {
      $ps1FullPath = $ps1.FullName
      Run-ChocolateyProcess powershell "$ps1FullPath" -elevated
			#testing Start-Process -FilePath "powershell.exe" -ArgumentList " -noexit `"$ps1FullPath`"" -Verb "runas"  -Wait  #-PassThru -UseNewEnvironment #-RedirectStandardError $errorLog -WindowStyle Normal
    }
  }
}

function Get-ChocolateyBins {
param([string] $packageFolder)
  if ($packageFolder -notlike '') { 
@"
$h2
Executable Batch Links
$h2
Looking for executables in folder: $packageFolder
Adding batch files for any executables found to a location on PATH.
In other words, the executable will be available from ANY command line/powershell prompt.
$h2
"@ | Write-Host
    try {
      $files = get-childitem $packageFolder -include *.exe -recurse
      foreach ($file in $files) {
        Generate-BinFile $file.Name.Replace(".exe","") $file.FullName
      }
    }
    catch {
      Write-Host 'There are no executables in the package. You may not need this as a #chocolatey #nuget. A vanilla #nuget may suffice.'
    }
    Write-Host "$h2"
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
@"
$h1
Chocolatey - Your local machine NuGet repository AKA your local tools repository  AKA apt-get for Windows
Version $chocVer
$h1
Chocolatey allows you to install application nuggets and run executables from anywhere.
$h2
Known Issues
$h2
None known right now.
$h2
Release Notes
$h2
v0.9.1 
 * Shortcut for 'chocolatey install' - 'cinst' now available.
v0.9.2
 * List command added.	
v0.9.3 
 * You can now pass -source and -version to install command
v0.9.4 
 * List command has a filter.
 * Package license acceptance terms notated
v0.9.5 
 * Helper for native installer.	Reduces the amount of powershell necessary to download and install a native package to two lines from over 25.
 * Helper outputs progress during download.
 * Dependency runner is complete
v0.9.6
 * Can execute powershell and chocolatey without having to change execution rights to powershell system wide.
$h2
Package License Acceptance Terms
$h2
The act of running chocolatey to install a package constitutes acceptance of the license for the application, executable(s), or other artifacts that are brought to your machine as a result of a chocolatey install.
This acceptance occurs whether you know the license terms or not. It is suggested that you read and understand the license terms of any package you plan to install prior to installation through chocolatey.
If you do not accept the license of a package you are installing, please uninstall it and any artifacts that end up on your machine as a result of the install.
$h2
Usage
$h2
chocolatey [install packageName  [-source source] [-version version]|update packageName [-source source] [-version version]|list [packageName] [-source source]|help]

example: chocolatey install nunit
example: chocolatey install nunit -version 2.5.7.10213
example: chocolatey update nunit -source http://somelocalfeed.com/nuget/
example: chocolatey help
example: chocolatey list (might take awhile)
example: chocolatey list nunit

A shortcut to 'chocolatey install' is cinst
cinst packageName  [-source source] [-version version]
example: cinst 7zip
example: cinst ruby -version 1.8.7
$h1
"@ | Write-Host
}

function Chocolatey-List {
  param([string]$selector='', [string]$source='https://go.microsoft.com/fwlink/?LinkID=206669');
  
  $parameters = "list /source $source"
  
  if ($selector -ne '') {
	$parameters = "$parameters ""$selector"""
  }
  
  Start-Process $nugetExe -ArgumentList $parameters -NoNewWindow -Wait 
}

function Chocolatey-Version {
param([string]$packageName='',[string]$source='https://go.microsoft.com/fwlink/?LinkID=206669')
	if ($packageName -eq '') {$packageName = 'chocolatey'}

	$logFile = Join-Path $nugetChocolateyPath 'list.log'
  Start-Process $nugetExe -ArgumentList "list /source $source ""$packageName""" -NoNewWindow -Wait -RedirectStandardOutput $logFile
	Start-Sleep 1 #let it finish writing to the config file
	
	$versionLatest = Get-Content $logFile | ?{$_ -match "^$packageName\s+\d+"} | sort $_ -Descending | select -First 1 
	$versionLatest = $versionLatest -replace "$packageName ", "";

	$versionFound = $chocVer
  if ($packageName -ne 'chocolatey') {
    $versionFound = 'no version'
		$packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "^$packageName*"} | sort name -Descending | select -First 1 
		
		if ($packageFolder -notlike '') { 
			Write-Host $packageFolder
			$versionFound = $packageFolder.Name -replace "$packageName\."
		}
  }
  
	if ($versionLatest -eq $versionFound) { 
		Write-Host "You have the latest version of $packageName ($versionLatest) based on ($source)."
	} else {
		Write-host "The most recent version of $packageName available from ($source) is $versionLatest. On your machine you have $versionFound installed."
	}
}

#main entry point
switch -wildcard ($command) 
{
  "install" { Chocolatey-NuGet  $packageName $source $version; }
  "update" { Chocolatey-NuGet $packageName $source $version; } #todo: called with no parameters should update every package installed
  "list" { Chocolatey-List $packageName $source; }
  "version" { Chocolatey-Version $packageName $source; }
  default { Chocolatey-Help; }
}
