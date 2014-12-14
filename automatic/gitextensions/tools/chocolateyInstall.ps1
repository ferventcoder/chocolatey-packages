try {

  $packageId = '{{PackageName}}'
  $installerType = 'msi'
  $installArgs = '/quiet /norestart'
  # In case you see \{\{DownloadUrlx64\}\} (without backslashes)
  # after the commented lines, it’s intended.
  $url = '{{DownloadUrlx64}}'

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
