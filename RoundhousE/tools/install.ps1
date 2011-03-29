param($installPath, $toolsPath, $package, $project)

Write-Host 'This is not a package with dlls to reference in it.'
Write-Host 'RoundhousE is a tool that can be local with your project or installed to the machine. If you want to do a machine install, please install using chocolatey' 
Write-Host "To get chocolatey just run 'Install-Package chocolatey' followed by 'Initialize-Chocolatey'"
Write-Host 'chocolatey install roundhouse'
Write-Host 'If you are wanting to add this to your project for deployment/migrations, you may keep it where it is and pull it in with your build scripts or manually move it somewhere more manageable.'
Write-Host 'In the future this script will do more towards automatically moving adding itself to a more conventional location when installed with vanilla #nuget.'