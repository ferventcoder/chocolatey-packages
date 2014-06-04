try {
  Install-ChocolateyPackage 'git.install' 'exe' '/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /NOICONS  /COMPONENTS="assoc,assoc_sh" /LOG' 'https://github.com/msysgit/msysgit/releases/download/Git-1.9.2-preview20140411/Git-1.9.2-preview20140411.exe'

  #------- ADDITIONAL SETUP -------#
  $is64bit = (Get-WmiObject Win32_Processor).AddressWidth -eq 64
  $programFiles = $env:programfiles
  if ($is64bit) {$programFiles = ${env:ProgramFiles(x86)}}
  $gitPath = Join-Path $programFiles 'Git\cmd'

  Install-ChocolateyPath $gitPath 'user'

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
