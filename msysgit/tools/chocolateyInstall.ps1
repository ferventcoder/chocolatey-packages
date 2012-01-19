try {
  Install-ChocolateyPackage 'msysgit' 'exe' '/SILENT' 'http://msysgit.googlecode.com/files/Git-1.7.8-preview20111206.exe'

  #------- ADDITIONAL SETUP -------#
  $is64bit = (Get-WmiObject Win32_Processor).AddressWidth -eq 64
  $progFiles = $env:programfiles
  if ($is64bit) {$progFiles = (get-item "env:PROGRAMFILES(X86)").value}
  $gitPath = Join-Path $progFiles 'Git\cmd'

  Install-ChocolateyPath $gitPath

@"

Making GIT core.autocrlf false
"@ | Write-Host

  #make GIT core.autocrlf false
  & "$env:comspec" '/c git config --global core.autocrlf false'

  Write-ChocolateySuccess 'msysgit'
} catch {
  Write-ChocolateyFailure 'msysgit' $($_.Exception.Message)
  throw
}
