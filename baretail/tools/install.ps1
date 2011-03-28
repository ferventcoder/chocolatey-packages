param($installPath, $toolsPath, $package, $project)

Write-Host 'This is not a package with dlls to reference in it.'
Write-Host 'Please install using chocolatey (Install-Package chocolatey)'
Write-Host 'chocolatey install baretail'
write-host 'Removing this package...'
uninstall-package baretail -ProjectName $project.Name