$packageName = 'disableuac'

try {
  $uacRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
  $uacRegValue = "EnableLUA"
  $uacEnabled = $false

  # https://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
  $osVersion = [Environment]::OSVersion.Version
  if ($osVersion -ge [Version]'6.0')
  {
    $uacRegSetting = Get-ItemProperty -Path $uacRegPath
    try {
      $uacValue = $uacRegSetting.EnableLUA
      if ($uacValue -eq 1) {
        $uacEnabled = $true
      } else {
        Write-Host "UAC is already disabled."
      }
    } catch {}
  } else {
    Write-Host "UAC doesn't exist on this machine."
  }

  if ($uacEnabled) {
    Start-ChocolateyProcessAsAdmin "Set-ItemProperty -Path `"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`" -Name `"EnableLUA`" -Value 0"
    Write-Host "UAC has been disabled"
  }

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}

