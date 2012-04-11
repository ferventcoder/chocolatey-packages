try {
  Install-ChocolateyPackage 'msysgit' 'exe' '/SILENT' 'http://msysgit.googlecode.com/files/Git-1.7.10-preview20120409.exe'

  #------- ADDITIONAL SETUP -------#
  $is64bit = (Get-WmiObject Win32_Processor).AddressWidth -eq 64
  $programFiles = $env:programfiles
  if ($is64bit) {$programFiles = ${env:ProgramFiles(x86)}}
  $gitPath = Join-Path $programFiles 'Git\cmd'

  Install-ChocolateyPath $gitPath 'user'

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
