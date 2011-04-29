try {
  Install-ChocolateyZipPackage 'ghostdoc' 'http://submain.com/download/GhostDoc_v3.0.zip' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  
  #after download we need to run the installer against it
  #then we need to delete the files prior to the chocolatey bins
  
  #------- ADDITIONAL SETUP -------#

  #$processor = Get-WmiObject Win32_Processor
  #$is64bit = $processor.AddressWidth -eq 64

  # stuff here?

  write-host "ghostdoc has been installed."
  Start-Sleep 6

} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 8
	throw 
}