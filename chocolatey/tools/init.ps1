param($installPath, $toolsPath, $package, $project)

#========================
#Chocolatey - NuGet local machine repo
#========================
#chocolatey

#import sudo
$modules = Get-ChildItem $ToolsPath -Filter *.psm1
$modules | ForEach-Object { import-module -name  $_.FullName }

Write-Host '========================'
write-host 'Chocolatey'
Write-Host '=========='
write-host 'Welcome to Chocolatey, your local machine repository for NuGet. Chocolatey allows you to install application packages to your machine with the goodness of a #chocolatey #nuget combo.' 
Write-Host 'Application executables get added to the path automatically so you can call them from anywhere (command line/powershell prompt), not just in Visual Studio.'
Write-Host ''
write-host 'Lets get Chocolatey!'
Write-Host '----------'
write-host 'Visual Studio -'
Write-Host '----------'
write-host 'Please run Initialize-Chocolatey one time per machine to set up the repository.' 
write-host 'If you are upgrading, please remember to run Initialize-Chocolatey again.'
Write-Host 'After you have run Initiliaze-Chocolatey, you can safely uninstall the chocolatey package from your current Visual Studio solution.'
Write-Host '----------'
Write-Host 'Alternative NuGet -'
Write-Host '----------'
Write-Host 'If you are not using NuGet in Visual Studio, please navigate to the directory with the chocolateysetup.psm1 and run that in Powershell, followed by Initialize-Chocolatey.'
Write-Host 'Upgrade is the same, just run Initialize-Chocolatey again.'
Write-Host '----------'
Write-Host '========================'
#========================