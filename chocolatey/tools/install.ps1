param($installPath, $toolsPath, $package, $project)

#========================
#Chocolatey - NuGet local machine repo
#========================
#chocolatey

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

#get the PATH variable
$envPath = $env:PATH

#if you do not find C:\NuGet\bin, add it 
if ($envPath.ToLower().Contains($nugetExePath.ToLower()))
{
  #does the path end in ';'?
  $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
  # if the last digit is not ;, then we are adding it
  If (!$hasStatementTerminator) {$nugetExePath = $statementTerminator + $nugetExePath}
  #now we update the path
  $envPath = $envPath + $nugetExePath + $statementTerminator
  [Environment]::SetEnvironmentVariable( "Path", $envPath, [System.EnvironmentVariableTarget]::Machine )
}
#========================

write-host Removing this package...
#uninstall-package $package.Name -ProjectName $project.Name
uninstall-package chocolatey -ProjectName $project.Name