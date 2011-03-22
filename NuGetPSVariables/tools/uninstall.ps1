param($installPath, $toolsPath, $package, $project)

$tempDir = $env:TEMP
$tempDir = [System.IO.Path]::Combine($tempDir,"NuGetPSVariables")
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = [System.IO.Path]::Combine($tempDir, "nuget.variables.uninstall.ps1.log")
write-host ===================================================
write-host uninstall.ps1
write-host ===================================================
'===================================================' | out-file $file
'uninstall.ps1' | out-file $file -append 
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