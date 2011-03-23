function Request-ElevatedChocolateyPermissions
{
	$file, [string]$arguments = $args;
	$psi = new-object System.Diagnostics.ProcessStartInfo $file;
	$psi.Arguments = $arguments;
	$psi.Verb = "runas";
	$psi.WorkingDirectory = get-location;
	[System.Diagnostics.Process]::Start($psi);
}

Set-Alias sudo-chocolatey Request-ElevatedChocolateyPermissions;

function Install-Chocolatey {
  #set up variables to add
  $statementTerminator = ";"
  $nugetPath = "C:\NuGet"
  $nugetExePath = [System.IO.Path]::Combine($nuGetPath, "bin")
  $nugetLibPath = [System.IO.Path]::Combine($nuGetPath, "lib")

  $nugetYourPkgPath = [System.IO.Path]::Combine($nugetLibPath,"yourPackageName")
  Write-Host We are setting up the Chocolatey repository for NuGet packages that should be at the machine level
  Write-Host The repository is set up at $nugetPath.
  Write-Host The packages themselves go to $nugetLibPath '(i.e.' $nugetYourPkgPath ').'
  Write-Host A batch file for the command line goes to $nugetExePath and points to an executable in $nugetYourPkgPath.

  #create the base structure if it doesn't exist
  if (![System.IO.Directory]::Exists($nugetExePath)) {[System.IO.Directory]::CreateDirectory($nugetExePath)}
  if (![System.IO.Directory]::Exists($nugetLibPath)) {[System.IO.Directory]::CreateDirectory($nugetLibPath)}

  #get the PATH variable from the machine
  #$envPath = $env:PATH
  $envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

  #if you do not find C:\NuGet\bin, add it 
  if (!$envPath.ToLower().Contains($nugetExePath.ToLower()))
  {
    #does the path end in ';'?
    $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator) {$nugetExePath = $statementTerminator + $nugetExePath}
	
    Write-Host
	#now we update the path
    Write-Host Adding $nugetExePath to the PATH variable
    $envPath = $envPath + $nugetExePath + $statementTerminator
	
	#[Environment]::SetEnvironmentVariable( "Path", $envPath, [System.EnvironmentVariableTarget]::Machine )
	$psArgs = "[Environment]::SetEnvironmentVariable( 'Path', '" + $envPath + "', [System.EnvironmentVariableTarget]::Machine )"  #-executionPolicy Unrestricted"
	
	Write-Host 
	Write-Host You may be being asked for permission to add $nugetExePath to the PATH system environment variable. This gives you the ability to execute nuget applications from the command line.
	Write-Host Please select [Yes] when asked for privileges...
	#Write-Host powershell $psArgs
	
	sudo-chocolatey powershell "$psArgs"
	
	Write-Host 
	Write-Host Chocolatey is now installed and ready.
  }
}

function Get-Chocolatey
{
param(
    [string] $package,
    [string] $executableName
    )
}

Set-Alias Chocolatey-NuGet Get-Chocolatey;

export-modulemember -function Request-ElevatedChocolateyPermissions
export-modulemember -function Install-Chocolatey
export-modulemember -function Get-Chocolatey