$packageName = 'paint.net'
$msiProductCodeGuid = '{DF3A46D9-67B3-44B2-9D01-25C8BA772C8A}'
$shouldUninstall = $true

$installerType = 'MSI' 
$silentArgs = "$msiProductCodeGuid /qn /norestart"
$validExitCodes = @(0, 3010, 1605, 1614, 1641)
$file = ''

if ($shouldUninstall) {
 #Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $file
 Start-Process -FilePath 'msiexec.exe' -ArgumentList "/X$silentArgs" -Verb RunAs
}
