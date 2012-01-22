$binRoot = "$env:systemdrive\"
if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}

$rubyFolder = '187'
$url = 'http://rubyforge.org/frs/download.php/75679/rubyinstaller-1.8.7-p357.exe'

# $rubyFolder = '192'
# $url = 'http://rubyforge.org/frs/download.php/75127/rubyinstaller-1.9.2-p290.exe'

$rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
$silentArgs = "/silent /dir=`"$rubyPath`""

Install-ChocolateyPackage 'ruby' 'exe' "$silentArgs" "$url"

$toolsPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$parentPath = join-path $toolsPath '..'
$contentPath = join-path $parentPath 'content'
$infFile = join-path $contentPath 'RubyScriptIcon.inf'

# Update the inf file with the content path
Get-Content $infFile | Foreach-Object{$_ -replace "CONTENT_PATH", "$contentPath"} | Set-Content 'TempFile.txt'
move-item 'TempFile.txt' $infFile -Force

# install the inf file
& rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 $infFile

# Install and configure pik
$rubyBin = join-path $rubyPath 'bin'
$nugetBin = join-path $env:chocolateyinstall 'bin'
$gem = join-path $rubyBin 'gem.bat'
$pikInstall = join-path $rubyBin 'pik_install.bat'
& $gem install pik
& $pikInstall "$nugetBin"

& pik add $rubyBin
& pik use $rubyFolder
