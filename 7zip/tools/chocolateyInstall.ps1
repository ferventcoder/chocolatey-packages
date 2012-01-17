try {
  Install-ChocolateyPackage '7Zip' 'msi' '/quiet' 'http://sourceforge.net/projects/sevenzip/files/7-Zip/9.22/7z922.msi' 'http://sourceforge.net/projects/sevenzip/files/7-Zip/9.22/7z922-x64.msi'

  $programFiles = $env:ProgramFiles

  $is64bit = (Get-WmiObject Win32_Processor).AddressWidth -eq 64
  if ($is64bit) {
    $programFiles = $env:ProgramW6432;
  }

  Install-ChocolateyPath  "$(join-path $programFiles '7-Zip')"

  Write-ChocolateySuccess '7Zip'
} catch {
  Write-ChocolateyFailure '7Zip' $($_.Exception.Message)
  throw 
}