param($installPath, $toolsPath, $package, $project)

$tempDir = $env:TEMP
$tempDir = [System.IO.Path]::Combine($tempDir,"NuGetPSVariables")
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = [System.IO.Path]::Combine($tempDir, "nuget.variables.install.ps1.log")
write-host ===================================================
write-host install.ps1
write-host ===================================================
'===================================================' | out-file $file
'install.ps1' | out-file $file -append 
'===================================================' | out-file $file -append 

write-host '$installPath' variable = $installPath
'$installPath'  | out-file $file -append 
'=============='  | out-file $file -append 
$installPath | format-list | out-file $file -append
'=============='  | out-file $file -append 

write-host '$toolsPath' variable = $toolsPath
'$toolsPath'  | out-file $file -append 
'=============='  | out-file $file -append 
$toolsPath | format-list | out-file $file -append
'=============='  | out-file $file -append 

write-host '$package' variable = $package
'$package'  | out-file $file -append 
'=============='  | out-file $file -append 
$package | format-list | out-file $file -append
'=============='  | out-file $file -append 

write-host '$project' variable = $project
'$project'  | out-file $file -append 
'=============='  | out-file $file -append 
$project | format-list | out-file $file -append
'=============='  | out-file $file -append 

write-host Writing output to $file
write-host ===================================================

write-host Removing this package...
#uninstall-package $package.Name -ProjectName $project.Name
uninstall-package NuGetPSVariables -ProjectName $project.Name

#$project | Get-Member -View Adapted | foreach {write-host $_.Name : $_.Value}
#$project | Get-Member | foreach {write-host $_.name}
#thanks Keith: $project | Get-Member -MemberType Property | foreach {write-host "$($_.Name) : $($project.$($_.Name))"}