try {

  $packageId = '{{PackageName}}'
  $fileType = 'exe'
  $fileArgs = $(
    '/VERYSILENT /NORESTART /NOCANCEL /SP- ' +
    '/NOICONS /COMPONENTS="assoc,assoc_sh" /LOG'
  )
  $url = '{{DownloadUrl}}'

  Install-ChocolateyPackage $packageId $fileType $fileArgs $url

  #------- ADDITIONAL SETUP -------#
  #$uninstallKey = 'Git_is1'
  #$key = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$uninstallKey"
  #HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1
  #HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1
  #HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1
  #$key = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1'
  #Test-Path $key
  #(Get-ItemProperty -Path $key -Name ProgramFilesDir).ProgramFilesDir
  $is64bit = (Get-ProcessorBits) -eq 64
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

  Write-ChocolateySuccess $packageId
} catch {
  Write-ChocolateyFailure $packageId $($_.Exception.Message)
  throw
}

