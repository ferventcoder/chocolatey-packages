try {
  Install-ChocolateyPackage 'git.install' 'exe' '/VERYSILENT /NORESTART /NOCANCEL /SP- /NOICONS  /COMPONENTS="assoc,assoc_sh,ext\reg\shellhere,ext\reg\guihere" /LOG' '{{DownloadUrl}}'

  #------- ADDITIONAL SETUP -------#
  #$uninstallKey = 'Git_is1'
  #$key = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$uninstallKey"
  #HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1
  #HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1
  #HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1
  #$key = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1'
  #Test-Path $key
  #(Get-ItemProperty -Path $key -Name ProgramFilesDir).ProgramFilesDir
  $is64bit = (Get-WmiObject Win32_Processor).AddressWidth -eq 64
  $programFiles = $env:programfiles
  if ($is64bit) {$programFiles = ${env:ProgramFiles(x86)}}
  $gitPath = Join-Path $programFiles 'Git\cmd'

  Install-ChocolateyPath $gitPath 'Machine'

#@"
#
#Making GIT core.autocrlf false
#"@ | Write-Host
#
#  #make GIT core.autocrlf false
#  & "$env:comspec" '/c git config --global core.autocrlf false'

  Write-ChocolateySuccess 'git.install'
} catch {
  Write-ChocolateyFailure 'git.install' $($_.Exception.Message)
  throw
}

