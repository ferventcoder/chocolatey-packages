$nugetPath = 'C:\NuGet'
$nugetLibPath = Join-Path $nuGetPath 'lib'

$packageFolder = Get-ChildItem $nugetLibPath | ?{$_.name -match "expresso*"} | sort name -Descending | select -First 1 
if ($packageFolder -notlike '') {
  $installPath = "$($packageFolder.FullName)\bin\ExpressoSetup3.msi"
  write-host 'Installing Expresso 3 from ' $installPath 
  
  msiexec /i "$installPath"  /quiet
  
  write-host 'Expresso installed successfully'
 
} 
Start-Sleep 3