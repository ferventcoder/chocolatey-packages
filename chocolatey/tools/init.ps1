param($installPath, $toolsPath, $package, $project)

#========================
#Chocolatey - NuGet local machine repo
#========================
#chocolatey

#import sudo
$modules = Get-ChildItem $ToolsPath -Filter *.psm1
$modules | ForEach-Object { import-module -name  $_.FullName }

write-host Welcome to Chocolatey, the machine repository for NuGet. Please run Install-Chocolatey one time per machine to set up the repository.
#========================