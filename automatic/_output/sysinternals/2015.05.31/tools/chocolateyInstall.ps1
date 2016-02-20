
$packageName = 'sysinternals'
$url = 'http://download.sysinternals.com/files/SysinternalsSuite.zip'
$installDir = Split-Path -parent $MyInvocation.MyCommand.Definition

Install-ChocolateyZipPackage $packageName $url $installDir


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


Write-Warning "Clean up older versions of this install, most likely at c:\sysinternals"