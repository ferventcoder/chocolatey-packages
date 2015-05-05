Write-Debug ("Starting " + $MyInvocation.MyCommand.Definition)

[string]$packageName="Adobe Reader"

<#
Exit Codes:
    0: installed successfully.
    1605: not installed.
    3010: A reboot is required to finish the install.
#>

#Kill Processes
echo "Killing Processes..."
if (Stop-Process -processname AdobeARM -PassThru -ErrorAction SilentlyContinue){
echo "Killed updater..."
}
if (Stop-Process -processname AcroRd32 -PassThru -ErrorAction SilentlyContinue){
echo "Killed Reader..."
}
echo "Begining uninstall..."
Start-ChocolateyProcessAsAdmin "/qn /norestart /X{AC76BA86-7AD7-FFFF-7B44-AC0F074E4100}" -exeToRun "msiexec.exe" -validExitCodes @(0,1605,3010) 
echo "Uninstall Complete!"

Write-Warning "$packageName may require a reboot to complete the uninstallation."