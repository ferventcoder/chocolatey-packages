try {
    Install-ChocolateyPackage 'kdiff3' 'exe' '/S' 'http://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.95/KDiff3Setup_0.9.95-2.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fkdiff3%2Ffiles%2Fkdiff3%2F0.9.95%2F&ts=1302319944&use_mirror=superb-sea2' 
    
  #------additional setup ----------------
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit) {$progFiles = "$progFiles (x86)"}
  $programPath = Join-Path $progFiles 'kdiff3'
  
  Install-ChocolateyPath $programPath
  
  Write-ChocolateySuccess 'kdiff3'
} catch {
  Write-ChocolateyFailure 'kdiff3' $($_.Exception.Message)
  throw 
}