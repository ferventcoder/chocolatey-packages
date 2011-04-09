param($command,$packageName='',$source='https://go.microsoft.com/fwlink/?LinkID=206669',$version='')#todo:,[switch] $silent)

#Chocolatey
$chocVer = '0.9.4.0'
$nugetPath = 'C:\NuGet'
$nugetExePath = Join-Path $nuGetPath 'bin'
$nugetLibPath = Join-Path $nuGetPath 'lib'
$nugetChocolateyPath = Join-Path $nuGetPath 'chocolateyInstall'
$nugetExe = Join-Path $nugetChocolateyPath 'nuget.exe'
$h1 = '====================================================='
$h2 = '-------------------------'

function Run-ChocolateyProcess {
param([string]$file, [string]$arguments = $args, [switch] $elevated);

#@"
#`$file = $file
#`$arguments =  $arguments
#`$elevated = $($elevated.isPresent)
#"@
  $psi = new-object System.Diagnostics.ProcessStartInfo $file;
  $psi.Arguments = $arguments;
  #$psi.UseShellExecute = $false
  #$psi.CreateNoWindow = $true
  #$psi.RedirectStandardError = $true
  #$psi.RedirectStandardOutput = $true
	#if ($elevated.isPresent) {
		Write-Host "Elevating Permissions";
		$psi.Verb = "runas";
	#}
  $psi.WorkingDirectory = get-location;
 
  $s = [System.Diagnostics.Process]::Start($psi);
#  Register-ObjectEvent $s OutputDataReceived -Action { 
#                                                        $global:stdout = $global:stdout + $args[1].Data; 
#                                                        write-host $args[1].Data; 
#                                                     }
  #$s.BeginOutputReadLine();
  #$stdout = $s.StandardOutput.ReadToEnd();
  #$stderr = $s.StandardError.ReadToEnd();
  $s.WaitForExit(300000);
  
  #?? $stdout $stderr | write-host
  #return ?? $stdout $stderr
}

function Chocolatey-NuGet { 
#[string]$install,[string]$packageName,[string]$arguments = $args;
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

@"
$h2
NuGet
$h2
"@ | Write-Host

	#todo: If package name is non-existant or is set to all, it means we are going to update all currently installed packages.

  $packageArgs = "install $packageName /outputdirectory `"$nugetLibPath`" /source $source"
  if ($version -notlike '') {
    $packageArgs = $packageArgs + " /version $version";
  }
  $logFile = Join-Path $nugetChocolateyPath 'install.log'
  Start-Process $nugetExe -ArgumentList $packageArgs -NoNewWindow -Wait -RedirectStandardOutput $logFile
  #Start-Process $nugetExe -ArgumentList $packageArgs -NoNewWindow -Wait |Tee-Object $logFile | Write-Host
  foreach ($line in Get-Content $logFile -Encoding Ascii) {
    Write-Host $line
    #todo: get the name of the packages and their versions
  }
  
@"
$nugetOutput
$h2
"@ | Write-Host  

  if ($packageName -notlike '') {
    Run-ChocolateyPS1 $packageName
    Get-ChocolateyBins $packageName
  }
  
@"
$h1
Chocolatey has finished installing $packageName
$h1
"@ | Write-Host
}

function Run-ChocolateyPS1 {
param([string] $packageName)
  $packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "^$packageName*"} | sort name -Descending | select -First 1 
  if ($packageFolder) { 
@"
$h2
Chocolatey Installation (chocolateyinstall.ps1)
$h2
Looking for chocolateyinstall.ps1 in folder: $($packageFolder.FullName)
If chocolateyInstall.ps1 is found, it will be run.
$h2
"@ | Write-Host

    $ps1 = Get-ChildItem  $packageFolder.FullName -recurse | ?{$_.name -match "chocolateyinstall.ps1"} | sort name -Descending | select -First 1
    
    if ($ps1 -notlike '') {
      $ps1FullPath = $ps1.FullName
      Write-Host "Running against $ps1FullPath. This may take awhile, depending on the package."
      Run-ChocolateyProcess powershell "$ps1FullPath" -elevated
    }
  }
}

function Get-ChocolateyBins {
param([string] $packageName)
  #search the lib directory for the highest number of the folder
  $packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "^$packageName*"} | sort name -Descending | select -First 1 
  if ($packageFolder -notlike '') { 
@"
$h2
Executable Batch Links
$h2
Looking for executables in folder: $($packageFolder.FullName)
Adding batch files for any executables found to a location on PATH.
In other words, the executable will be available from ANY command line/powershell prompt.
$h2
"@ | Write-Host
    try {
      $files = get-childitem $packageFolder.FullName -include *.exe -recurse
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
Usage
$h2
chocolatey [install packageName  [-source source] [-version version]|update packageName [-source source] [-version version]|list [packageName] [-source source]|help]

example: chocolatey install nunit
example: chocolatey install nunit -version 2.5.7.10213
example: chocolatey update nunit http://somelocalfeed.com/nuget/
example: chocolatey help
example: chocolatey list (might take awhile)
example: chocolatey list nunit

A shortcut to install is cinst
cinst packageName  [-source source] [-version version]
example: cinst 7zip
example: cinst ruby -version 1.8.7

$h2
Package License Acceptance Terms
$h2
The act of running chocolatey to install a package constitutes acceptance of the license for the application, executable(s), or other artifacts that are brought to your machine as a result of a chocolatey install.
This acceptance occurs whether you know the license terms or not. It is suggested that you read and understand the license terms of any package you plan to install prior to installation through chocolatey.
If you do not accept the license of a package you are installing, please uninstall it and any artifacts that end up on your machine as a result of the install.
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
			#todo get version from the folder name
			#$versionFound = $packageFolder.
		}
  }
  Write-host "The most recent version of $packageName available from ($source) is $versionLatest. On your machine you have $versionFound installed."
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
