function Request-ElevatedChocolateyPermissions
{
  $file, [string]$arguments = $args;
  $psi = new-object System.Diagnostics.ProcessStartInfo $file;
  $psi.Arguments = $arguments;
  $psi.Verb = "runas";
  $psi.WorkingDirectory = get-location;
  $s = [System.Diagnostics.Process]::Start($psi);
	$s.WaitForExit(8000);
}

Set-Alias sudo-chocolatey Request-ElevatedChocolateyPermissions;

function Set-Packages-Environment-Folder($folder){
    if(test-path $folder){
        [Environment]::SetEnvironmentVariable("NuGetPackagesInstallationFolder", $folder, "User")
    }
    else{
        throw "Cannot set the packages install folder. Folder not found [$folder]"
    }
}

function Get-Packages-Environment-Folder(){
    [Environment]::GetEnvironmentVariable("NuGetPackagesInstallationFolder", "User")
    # Should this throw if the folder's not found?
}

function Select-Folder($message='Select a folder', $path = "C:\") { 
    $object = New-Object -comObject Shell.Application  
     
    $folder = $object.BrowseForFolder(0, $message, 0, $path) 
    if ($folder -ne $null) { 
        $folder.self.Path 
    } 
}

function Create-Directory-IfNotExists($folderName){
    if (![System.IO.Directory]::Exists($folderName)) {[System.IO.Directory]::CreateDirectory($folderName)}
}

function Create-ChocolateyBinFile {
param([string] $nugetChocolateyBinFile,[string] $nugetChocolateyInstallAlias)
    "@echo off
    ""$nugetChocolateyPath\chocolatey.cmd"" %*" | Out-File $nugetChocolateyBinFile -encoding ASCII
    "@echo off
    ""$nugetChocolateyPath\chocolatey.cmd"" install %*" | Out-File $nugetChocolateyInstallAlias -encoding ASCII
}

function Initialize-Chocolatey {
<#
	.DESCRIPTION
		This will initialize the Chocolatey tool by
			a) setting up the "nugetPath" (the location where all chocolatey nuget packages will be installed)
			b) Installs chocolatey into the "nugetPath"
			c) Adds chocolaty to the PATH environment variable so you have access to the chocolatey|cinst commands.
	.PARAMETER  NuGetPath
		Allows you to override the default path of (C:\NuGet\) by specifying a directory chocolaty will install nuget packages.

	.EXAMPLE
		C:\PS> Initialize-Chocolatey

		Installs chocolatey into the default C:\NuGet\ directory.

	.EXAMPLE
		C:\PS> Initialize-Chocolatey -nugetPath "D:\ChocolateyInstalledNuGets\"

		Installs chocolatey into the custom directory D:\ChocolateyInstalledNuGets\

#>
param(
  [Parameter(Mandatory=$false)]
  [string]$nugetPath = 'C:\NuGet'
)

  if(!(test-path $nugetPath)){
    mkdir $nugetPath | out-null
  }

  Set-Packages-Environment-Folder $nugetPath


  #set up variables to add
  $statementTerminator = ";"

  $nugetExePath = Join-Path $nuGetPath 'bin'
  $nugetLibPath = Join-Path $nuGetPath 'lib'
  $nugetChocolateyPath = Join-Path $nuGetPath 'chocolateyInstall'
  $nugetChocolateyBinFile = Join-Path $nugetExePath 'chocolatey.bat'
  $nugetChocolateyInstallAlias = Join-Path $nugetExePath 'cinst.bat'

  $nugetYourPkgPath = [System.IO.Path]::Combine($nugetLibPath,"yourPackageName")
@"
We are setting up the Chocolatey repository for NuGet packages that should be at the machine level. Think executables/application packages, not library packages.
That is what Chocolatey NuGet goodness is for.
The repository is set up at $nugetPath.
The packages themselves go to $nugetLibPath (i.e. $nugetYourPkgPath).
A batch file for the command line goes to $nugetExePath and points to an executable in $nugetYourPkgPath.

Creating Chocolatey NuGet folders if they do not already exist.

"@ | Write-Host

	#create the base structure if it doesn't exist
	Create-Directory-IfNotExists $nugetExePath
	Create-Directory-IfNotExists $nugetLibPath
	Create-Directory-IfNotExists $nugetChocolateyPath

	#$chocInstallFolder = Get-ChildItem .\ -Recurse | ?{$_.name -match  "chocolateyInstall*"} | sort name -Descending | select -First 1 
	$thisScript = (Get-Variable MyInvocation -Scope 1).Value 
	$thisScriptFolder = Split-Path $thisScript.MyCommand.Path
	$chocInstallFolder = Join-Path $thisScriptFolder "chocolateyInstall"
	Write-Host 'Copying the contents of ' $chocInstallFolder ' to ' $nugetPath '.'
	Copy-Item $chocInstallFolder $nugetPath –recurse -force
	Write-Host 'Creating ' $nugetChocolateyBinFile ' so you can call chocolatey from anywhere.'
	Create-ChocolateyBinFile $nugetChocolateyBinFile $nugetChocolateyInstallAlias
	Write-Host ''
		
  #get the PATH variable from the machine
  #$envPath = $env:PATH
  $envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

  #if you do not find $nugetPath\bin, add it 
  if (!$envPath.ToLower().Contains($nugetExePath.ToLower()))
  {
  	Write-Host ''
		#now we update the path
    Write-Host 'PATH environment variable does not have ' $nugetExePath ' in it. Adding.'
  
    #does the path end in ';'?
    $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator) {$nugetExePath = $statementTerminator + $nugetExePath}
    $envPath = $envPath + $nugetExePath + $statementTerminator

	  #[Environment]::SetEnvironmentVariable( "Path", $envPath, [System.EnvironmentVariableTarget]::Machine )
	  $psArgs = "[Environment]::SetEnvironmentVariable( 'Path', '" + $envPath + "', [System.EnvironmentVariableTarget]::Machine )"  #-executionPolicy Unrestricted"

@"

You may be being asked for permission to add $nugetExePath to the PATH system environment variable. This gives you the ability to execute applications from the command line.
Please select [Yes] when asked for privileges...

"@ | Write-Host
	  Start-Sleep 3

	  sudo-chocolatey powershell "$psArgs"
		
		#add it to the local path as well so users will be off and running
		$envPSPath = $env:PATH
		$env:Path = $envPSPath + $statementTerminator + $nugetExePath + $statementTerminator
	}

@"
Chocolatey is now ready.
You can call chocolatey from anywhere, command line or powershell by typing chocolatey.
Run chocolatey /? for a list of functions.
"@ | write-host
}

export-modulemember -function Initialize-Chocolatey;