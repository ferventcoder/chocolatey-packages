#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://download.skype.com/3694814915aaa38100bfa0933f948e65/partner/59/SkypeSetup.exe'
#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://www.filehippo.com/download/file/259b6846bb4006500ccf63cb24e28f2b2260a164052443f0844185aab288c9ac'
#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://download.skype.com/SkypeSetupFull.exe'

$packageName = "skype"
$fileType = "msi"
$silentArgs = "/qn /norestart"
$url = "http://download.skype.com/msi/SkypeSetup_6.11.0.102.msi"

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64

if ($is64bit) {
    $programUninstallEntryName = "Skype"
    $uninstallString = (Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select DisplayName, UninstallString | Where-Object {$_.DisplayName -like "$programUninstallEntryName*"}).UninstallString
} else {
    $programUninstallEntryName = "Skype"
    $uninstallString = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select DisplayName, UninstallString | Where-Object {$_.DisplayName -like "$programUninstallEntryName*"}).UninstallString
} # get the uninstall string of the installed Skype version from the registry

$uninstallString = "$uninstallString" -replace '[{]', '`{' # adding escape character to the braces
$uninstallString = "$uninstallString" -replace '[}]', '`} /passive /norestart' # to work properly with the Invoke-Expression command, add silent arguments

if ($uninstallString -ne "") {
    Invoke-Expression "$uninstallString" # start uninstaller of old version

    do {
    $uninstalled = -not ((Test-Path "$env:ProgramFiles\Skype") -or (Test-Path "${env:ProgramFiles(x86)}\Skype"))
    Start-Sleep -Seconds 5
    $i += 1
    if ($i -gt 12) {break} # exit loop if too much time passed
    } until ($uninstalled) # this loop waits until Skype is uninstalled
}

Install-ChocolateyPackage $packageName $fileType $silentArgs $url