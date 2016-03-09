
$packageName = 'sysinternals'
$url = 'https://live.sysinternals.com/files/SysinternalsSuite.zip'
$installDir = Split-Path -parent $MyInvocation.MyCommand.Definition

# Default the values
$defaultInstallDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$installDir = $defaultInstallDir

# Now parse the packageParameters using good old regular expression
if ($packageParameters -and $packageParameters.Length -gt 18) {
  if ($packageParameters.ToLower().SubString(0,18) -eq '/installationpath:') {
    Write-Host "You want to use a custom Installation Path"
    Write-Warning "By using a custom path, chocolatey will not uninstall sysinternals"
    $installDir = $packageParameters.ToLower().SubString(18,$packageParameters.Length - 18)
  }
}

Install-ChocolateyZipPackage $packageName $url $installDir

if ($installDir -eq $defaultInstallDir) {
  @(
  'AccessEnum',
  'ADExplorer',
  'AdInsight',
  'Autoruns',
  'Bginfo',
  'Cachset',
  'Dbgview',
  'Desktops',
  'disk2vhd',
  'DiskView',
  'LoadOrd',
  'pagedfrg',
  'portmon',
  'procexp',
  'Procmon',
  'RAMMap',
  'RootkitRevealer',
  'Tcpview',
  'vmmap',
  'ZoomIt'
  ) | % {
    New-Item "$installDir\$_.exe.gui" -Type file -Force | Out-Null
  }
}

Write-Warning "Clean up older versions of this install, most likely at c:\sysinternals"
