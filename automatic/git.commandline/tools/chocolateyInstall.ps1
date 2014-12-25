try {

  $packageId = '{{PackageName}}'

  $binRoot = Get-BinRoot
  $gitInstallDir = Join-Path $binRoot 'git'

  $deprecatedInstallDir = Join-Path $env:systemdrive 'git'

  if (Test-Path $deprecatedInstallDir) {

    $gitInstallDir = $deprecatedInstallDir

    Write-Host $(
      "Warning: Deprecated installation directory detected ('$deprecatedInstallDir'). " +
      "This package will continue to install there. If you want this message to " +
      "disappear, move the installation location to '$gitInstallDir' " +
      "and force install this package again."
    )
  }

  Write-Host "Chocolatey is installing git to '$gitInstallDir'"

  $url = '{{DownloadUrl}}'

  if (Test-Path $gitInstallDir) {
    Write-Host "Cleaning out the contents of '$gitInstallDir'"
    Remove-Item "$($gitInstallDir)\*" -Recurse -Force
  }

  Write-Host "Extracting the contents of Git Portable to '$gitInstallDir'"

  Install-ChocolateyZipPackage $packageId $url $gitInstallDir

  Install-ChocolateyPath $gitInstallDir 'user'
  $env:Path = "$($env:Path);$gitInstallDir"

  Install-ChocolateyPath "$($gitInstallDir)\cmd" 'user'
  $env:Path = "$($env:Path);$($gitInstallDir)\cmd"

#  Write-Host 'Making GIT core.autocrlf false'
#  #make GIT core.autocrlf false
#  & "$env:comspec" '/c git config --global core.autocrlf false'

  Write-ChocolateySuccess $packageId

} catch {
  Write-ChocolateyFailure $packageId $($_.Exception.Message)
  throw
}

