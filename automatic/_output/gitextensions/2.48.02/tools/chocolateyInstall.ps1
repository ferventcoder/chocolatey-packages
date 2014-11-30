try {
  # \{\{DownloadUrlx64\}\} is the required variable
  Install-ChocolateyPackage 'gitextensions' 'msi' '/quiet' 'http://sourceforge.net/projects/gitextensions/files/Git%20Extensions/Version%202.48.02/GitExtensions-2.48.02-Setup.msi/download'

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
