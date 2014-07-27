try { 
  Install-ChocolateyPackage 'gitextensions' 'msi' '/quiet' 'http://gitextensions.googlecode.com/files/GitExtensions232Setup.msi' 
  
  #------- ADDITIONAL SETUP -------#
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit -and $progFiles -notmatch 'x86') {$progFiles = "$progFiles (x86)"}

  $gitexPath = Join-Path $progFiles "GitExtensions"
  Write-Host "Adding `'$gitexPath`' to the PATH so you can call gitex from the command line."
  Install-ChocolateyPath $gitexPath
  
  Write-ChocolateySuccess 'gitextensions'
} catch {
  Write-ChocolateyFailure 'gitextensions' "$($_.Exception.Message)"
  throw 
}