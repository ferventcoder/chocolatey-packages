try {

  $packageId = 'gitextensions'
  $installerType = 'msi'
  $installArgs = '/quiet /norestart'
  # In case you see \{\{DownloadUrlx64\}\} (without backslashes)
  # after the commented lines, it’s intended.
  $url = 'http://sourceforge.net/projects/gitextensions/files/Git%20Extensions/Version%202.48.04/GitExtensions-2.48.04-Setup.msi/download'

  Install-ChocolateyPackage "$packageId" "$installerType" "$installArgs" "$url"

  #------- ADDITIONAL SETUP -------#
  $osBitness = Get-ProcessorBits
  $is64bit = $osBitness -eq 64

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit -and $progFiles -notmatch 'x86') {$progFiles = "$progFiles (x86)"}

  $gitexPath = Join-Path $progFiles 'GitExtensions'
  Write-Host "Adding `'$gitexPath`' to the PATH so you can call gitex from the command line."
  Install-ChocolateyPath $gitexPath
  $env:Path = "$($env:Path);$gitexPath"

  Write-ChocolateySuccess "$packageId"
} catch {
  Write-ChocolateyFailure "$packageId" "$($_.Exception.Message)"
  throw
}
