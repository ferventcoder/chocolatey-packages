$packageName = '{{PackageName}}'
$installerType = 'EXE'
$silentArgs = '/S'
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

$registryPath32 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SumatraPDF'
$registryPathWow6432 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SumatraPDF'

try {
 
  if (Test-Path $registryPath32) {
    $registryPath = $registryPath32
  }
 
  if (Test-Path $registryPathWow6432) {
    $registryPath = $registryPathWow6432
  }
 
  if ($registryPath) {
    $uninstallString = (Get-ItemProperty -Path $registryPath -Name 'UninstallString').UninstallString
  }
 
  if ($uninstallString) {
    Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $uninstallString
  }
 
} catch {
  throw $_.Exception
}