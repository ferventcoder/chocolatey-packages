$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName = 'toad.mysql'
$installerType = 'exe'
$url = 'http://usdownloads.quest.com.edgesuite.net/Repository/www.toadsoft.com/MySQL/ToadforMySQL_Freeware_6.3.0.642.zip'
$url64 = $url
$silentArgs = '/S'
$validExitCodes = @(0)

try {
  Install-ChocolateyZipPackage "$packageName" "$url" "$toolsDir" "$url64"

  $fileToInstall = Join-Path "$toolsDir" 'ToadforMySQL_Freeware_6.3.0.642.exe'

  Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" "$fileToInstall" -validExitCodes $validExitCodes

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
