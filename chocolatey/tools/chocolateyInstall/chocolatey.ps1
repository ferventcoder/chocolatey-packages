#Chocolatey's main functions

$nugetPath = 'C:\NuGet'
$nugetExePath = Join-Path $nuGetPath 'bin'
$nugetLibPath = Join-Path $nuGetPath 'lib'
$nugetChocolateyPath = Join-Path $nuGetPath 'chocolateyInstall'
$nugetExe = Join-Path $nugetChocolateyPath 'nuget.exe'
$h1 = '====================================================='
$h2 = '-------------------------'

#Thanks Keith! http://solutionizing.net/2008/12/20/powershell-coalesce-and-powershellasp-query-string-parameters/
function Coalesce-Args {
  (@($args | ?{$_}) + $null)[0]
}

Set-Alias ?? Coalesce-Args


function Run-ChocolateyProcess
{
  param([string]$file, [string]$arguments = $args, [switch] $elevated);
#@"
#`$file = $file
#`$arguments =  $arguments
#`$elevated = $($elevated.isPresent)
#"@
  $psi = new-object System.Diagnostics.ProcessStartInfo $file;
  $psi.Arguments = $arguments;
  $psi.UseShellExecute = $false
  $psi.CreateNoWindow = $true
  $psi.RedirectStandardError = $true
  $psi.RedirectStandardOutput = $true
	if ($elevated.isPresent) {
		Write-Host "Elevating Permissions"
		$psi.Verb = "runas";
	}
 
  $s = New-Object System.Diagnostics.Process;
  $s.StartInfo = $psi;
#  Register-ObjectEvent $s OutputDataReceived -Action { 
#                                                        $global:stdout = $global:stdout + $args[1].Data; 
#                                                        write-host $args[1].Data; 
#                                                     }
  $s.Start();
  #$s.BeginOutputReadLine();
  $stdout = $s.StandardOutput.ReadToEnd();
  $stderr = $s.StandardError.ReadToEnd();
	$s.WaitForExit(300000);
  
	return ?? $stdout $stderr
}

function Chocolatey-NuGet { 
#[string]$install,[string]$packageName,[string]$arguments = $args;
param([string] $packageName)

@"
$h1
Chocolatey is installing $packageName to "$nugetLibPath"
$h1
"@ | Write-Host

@"
$h2
NuGet
$h2
"@ | Write-Host

  $packageArgs = "install $packageName /outputdirectory ""$nugetLibPath"""
  $nugetOutput = Run-ChocolateyProcess "$nugetExe" "$packageArgs"
  #C:\NuGet\chocolateyInstall\NuGet.exe install $packageName /outputdirectory "$nugetLibPath"
  
@"
$nugetOutput
$h2
"@ | Write-Host  

  if ($packageName -notlike '') {
    Get-ChocolateyBins $packageName
	  Run-ChocolateyPS1 $packageName
  }
  
@"
$h1
Chocolatey has finished installing $packageName
$h1
"@ | Write-Host
}

function Get-ChocolateyBins {
param([string] $packageName)
  #search the lib directory for the highest number of the folder
  $packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "$packageName*"} | sort name -Descending | select -First 1 
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

function Run-ChocolateyPS1 {
param([string] $packageName)
  $packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "$packageName*"} | sort name -Descending | select -First 1 
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
Chocolatey - Your local machine NuGet Repository
$h1
Chocolatey allows you to install application nuggets and run executables from anywhere.
 
$h2
Usage
$h2
chocolatey [install packageName|update packageName|list|help]
  
example: chocolatey install nunit
example: chocolatey update nunit
example: chocolatey help
example: chocolatey list (might take awhile)
$h1
"@ | Write-Host
}

function Chocolatey-List {
  $list, [string]$arguments = $args;
	#something is not working right, so for now we spell out the whole path
  C:\NuGet\chocolateyInstall\NuGet.exe list
}

#main entry point
switch -wildcard ($args[0]) 
{
  "install" { Chocolatey-NuGet  $args[1]; }
  "update" { Chocolatey-NuGet  $args[1]; }
  "list" { Chocolatey-List; }
  default { Chocolatey-Help; }
}