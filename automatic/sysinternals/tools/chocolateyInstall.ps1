
$packageName = 'sysinternals'
$url = 'https://live.sysinternals.com/files/SysinternalsSuite.zip'
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

"Accepting Eula for all applications"
ls $installDir\*.exe | % { $k = "HKCU:/Software/Sysinternals/$($_.Name -replace '.exe$')"; mkdir $k -ea 0 -force; sp $k EulaAccepted 1 -ea 0}

Write-Warning "Clean up older versions of this install, most likely at c:\sysinternals"
