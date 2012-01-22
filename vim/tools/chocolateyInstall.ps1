$packageName = 'vim'
$fileType = 'exe'
$silentArgs = '/S'
$url = 'http://downloads.sourceforge.net/project/cream/Vim/7.3.401/gvim-7-3-401.exe'

Install-ChocolateyPackage $packageName $fileType $silentArgs $url

$toolsPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$parentPath = join-path $toolsPath '..'
$contentPath = join-path $parentPath 'content'

#install batch file in path
$nugetBin = join-path $env:chocolateyinstall 'bin'
copy-item $(join-path $contentPath 'gvim.cmd') $nugetBin

#add right click menu
$is64bit = (Get-WmiObject Win32_Processor).AddressWidth -eq 64
$infFile = 'EditWithVim.inf'
if ($is64bit) {$infFile = 'EditWithVim64.inf'}
$infFile = join-path $contentPath $infFile

# Update the inf file with the content path
Get-Content $infFile | Foreach-Object{$_ -replace "CONTENT_PATH", "$contentPath"} | Set-Content 'TempFile.txt'
move-item 'TempFile.txt' $infFile -Force

# install the inf file
& rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 $infFile
