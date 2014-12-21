try {

  $packageId = '{{packageName}}'

  Write-ChocolateySuccess $packageId

  $regPathWow6432 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\FileZilla Client'
  $regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FileZilla Client'

  if (Test-Path $regPathWow6432) {
    $existentRegPath = $regPathWow6432
  }

  if (Test-Path $regPath) {
    $existentRegPath = $regPath
  }

  if ($existentRegPath) {

    $uninstallString = (Get-ItemProperty $existentRegPath).UninstallString

    if ($uninstallString) {
      Uninstall-ChocolateyPackage $packageId 'exe' '/S' $uninstallString
    }

  }

} catch {

  Write-ChocolateyFailure $packageId $($_.Exception.Message)
  throw
}
