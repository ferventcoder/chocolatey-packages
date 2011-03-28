param($installPath, $toolsPath, $package, $project)

Write-Host 'This is not a package with dlls to reference in it.'
Write-Host 'Please install using chocolatey (Install-Package chocolatey)'
Write-Host 'chocolatey install ie9'
write-host 'Removing this package...'
uninstall-package ie9 -ProjectName $project.Name