try {
  Install-ChocolateyZipPackage 'ghostdoc' 'http://submain.com/download/GhostDoc_v3.0.zip' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

  #after download we need to run the installer against it
  #then we need to delete the files prior to the chocolatey bins

  #------- ADDITIONAL SETUP -------#

  #$processor = Get-WmiObject Win32_Processor
  #$is64bit = $processor.AddressWidth -eq 64

  # stuff here?

    Write-ChocolateySuccess 'ghostdoc'
} catch {
    Write-ChocolateyFailure 'ghostdoc' $($_.Exception.Message)
    throw
}
