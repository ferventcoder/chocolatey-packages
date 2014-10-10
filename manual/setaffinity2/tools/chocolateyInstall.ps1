try {
  $toolsDir ="$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  #$zipFile = join-path $toolsDir 'Set_Affinity_II_1.041.zip'
  Install-ChocolateyZipPackage 'setaffinity2' "http://www.bbses.info/mirrors/edgemeal.110mb.com/Files/Set_Affinity_II_1.041.zip" $toolsDir

  Rename-Item "$($toolsDir)\Set Affinity II.exe" 'setaffinity2.exe'

  Write-ChocolateySuccess 'setaffinity2'
} catch {
  Write-ChocolateyFailure 'setaffinity2' "$($_.Exception.Message)"
  throw
}
