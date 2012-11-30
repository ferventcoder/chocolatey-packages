$packageName = 'vim'
$fileType = 'exe'
$args = '/S'
$url = 'http://downloads.sourceforge.net/project/cream/Vim/7.3.736/gvim-7-3-736.exe'

Install-ChocolateyPackage $packageName $fileType $args $url

$installDir = Split-Path -Parent (Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Vim UninstallString).UninstallString
$statements = @"
`$installDir = Split-Path -Parent (Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Vim UninstallString).UninstallString

# special batch files we want to create
`$diffExeIgnore = Join-Path `$installDir "diff.exe.ignore"
`$uninstallExeIgnore = Join-Path `$installDir "uninstall.exe.ignore"
`$xxdExeIgnore = Join-Path `$installDir "xxd.exe.ignore"
`$gvimExeGui = Join-Path `$installDir "gvim.exe.gui;"
"@

Start-ChocolateyProcessAsAdmin ([string]::Concat($statements, "`nNew-Item `$diffExeIgnore,`$uninstallExeIgnore,`$xxdExeIgnore,`$gvimExeGui -Type File -Force | Out-Null"))
Get-ChocolateyBins $installDir
Start-ChocolateyProcessAsAdmin ([string]::Concat($statements, "`nRemove-Item `$diffExeIgnore,`$uninstallExeIgnore,`$xxdExeIgnore,`$gvimExeGui"))


