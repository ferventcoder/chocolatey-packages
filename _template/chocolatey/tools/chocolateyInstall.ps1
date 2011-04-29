#try {
  #choose from the following
  Install-ChocolateyPackage '__NAME__' 'EXE_OR_MSI' 'SILENT_ARGS' 'URL' '64BIT_URL_DELETE_IF_NO_64BIT' 
  #"/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer #msi is always /quiet
 
  Install-ChocolateyZipPackage '__NAME__' 'URL' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  
  #other helpers
  #Get-ChocolateyWebFile '__NAME__' 'DOWNLOAD_TO_FILE_FULL_PATH' 'URL' '64BIT_URL_DELETE_IF_NO_64BIT'
  #Install-ChocolateyInstallPackage '__NAME__' 'EXE_OR_MSI' 'SILENT_ARGS' '_FULLFILEPATH_'
  #$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  #Get-ChocolateyUnzip "FULL_LOCATION_TO_ZIP.zip" $scriptPath
  
  #------- ADDITIONAL SETUP -------#

  #$processor = Get-WmiObject Win32_Processor
  #$is64bit = $processor.AddressWidth -eq 64

  # stuff here?

  #write-host "__NAME__ has been installed."
  #Start-Sleep 6
#} catch {
#@"
#Error Occurred: $($_.Exception.Message)
#"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
#	Start-Sleep 8
#	throw 
#}