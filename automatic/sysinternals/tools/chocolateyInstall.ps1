
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

New-Item "HKCU:\SOFTWARE\Sysinternals" -Force | Out-Null
@("A","AccessChk","Active Directory Explorer","ADInsight","Autologon","AutoRuns","BGInfo","C","CacheSet","ClockRes","Coreinfo","Ctrl2cap","DbgView","Desktops","Disk2Vhd","Diskmon","DiskView","Du","EFSDump","FindLinks","Handle","Hex2Dec","Junction","LdmDump","ListDLLs","LoadOrder","Movefile","PageDefrag","PendMove","PipeList","Portmon","ProcDump","Process Explorer",  "Process Monitor","PsExec","psfile","PsGetSid","PsInfo","PsKill","PsList","PsLoggedon","PsLoglist","PsPasswd","PsService","PsShutdown","PsSuspend","RamMap","RegDelNull","Regjump","Regsize",  "RootkitRevealer","Share Enum","ShellRunas - Sysinternals: www.sysinternals.com","SigCheck","Streams","Strings","Sync","System Monitor","TCPView","VMMap","VolumeID","Whois","Winobj","ZoomIt") | % {
  New-Item (Join-Path -Path 'HKCU:\SOFTWARE\Sysinternals' -ChildPath "$_") -Force | New-ItemProperty -Name "EulaAccepted" -Value 1 -Force | Out-Null
  }

Write-Warning "Clean up older versions of this install, most likely at c:\sysinternals"
