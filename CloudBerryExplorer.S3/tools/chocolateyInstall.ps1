$packageName = 'CloudBerryExplorer.S3'
$installerType = 'exe'
$url = 'http://www.cloudberrylab.com/download/CloudBerryExplorerSetup_v3.7.0.31.exe'
$url64 = $url
$silentArgs = '/S' 
$validExitCodes = @(0) 

# main helpers - these have error handling tucked into them already
# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

#try { #error handling is only necessary if you need to do anything in addition to/instead of the main helpers
  # other helpers - using any of these means you want to uncomment the error handling up top and at bottom.
  # downloader that the main helpers use to download items
  #Get-ChocolateyWebFile "$packageName" 'DOWNLOAD_TO_FILE_FULL_PATH' "$url" "$url64"
  # installer, will assert administrative rights - used by Install-ChocolateyPackage
  #Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" '_FULLFILEPATH_' -validExitCodes $validExitCodes
  # unzips a file to the specified location - auto overwrites existing content
  #Get-ChocolateyUnzip "FULL_LOCATION_TO_ZIP.zip" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  # Runs processes asserting UAC, will assert administrative rights - used by Install-ChocolateyInstallPackage
  #Start-ChocolateyProcessAsAdmin 'STATEMENTS_TO_RUN' 'Optional_Application_If_Not_PowerShell' -validExitCodes $validExitCodes
  # add specific folders to the path - any executables found in the chocolatey package folder will already be on the path. This is used in addition to that or for cases when a native installer doesn't add things to the path.
  #Install-ChocolateyPath 'LOCATION_TO_ADD_TO_PATH' 'User_OR_Machine' # Machine will assert administrative rights
  # add specific files as shortcuts to the desktop
  #$target = Join-Path $MyInvocation.MyCommand.Definition "$($packageName).exe"
  #Install-ChocolateyDesktopLink $target
  
  #------- ADDITIONAL SETUP -------#
  # make sure to uncomment the error handling if you have additional setup to do

  #$processor = Get-WmiObject Win32_Processor
  #$is64bit = $processor.AddressWidth -eq 64

  
  # the following is all part of error handling
  #Write-ChocolateySuccess "$packageName"
#} catch {
  #Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  #throw 
#}