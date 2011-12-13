try {
  Install-ChocolateyPackage 'msysgit' 'exe' '/SILENT' 'http://msysgit.googlecode.com/files/Git-1.7.7.1-preview20111027.exe' 

  #------- ADDITIONAL SETUP -------#
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit -and $progFiles -notmatch 'x86') {$progFiles = "$progFiles (x86)"}
  $gitPath = Join-Path $progFiles 'Git\cmd'
  
  Install-ChocolateyPath $gitPath

@"

Making GIT core.autocrlf false
"@ | Write-Host

  #make GIT core.autocrlf false
  & 'cmd.exe' '/c git config --global core.autocrlf false'
  
  Write-ChocolateySuccess 'msysgit'
} catch {
  Write-ChocolateyFailure 'msysgit' $($_.Exception.Message)
  throw 
}