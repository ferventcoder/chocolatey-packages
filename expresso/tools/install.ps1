param($installPath, $toolsPath, $package, $project)

Write-Host 'This is not a package with dlls to reference in it.'
Write-Host 'Please install using chocolatey (you can get with install-package chocolatey)'
Write-Host 'chocolatey install expresso'
write-host 'Removing this package...'
uninstall-package expresso -ProjectName $project.Name