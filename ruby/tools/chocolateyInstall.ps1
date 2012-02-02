$binRoot = "$env:systemdrive\"

### Using an environment variable to to define the bin root until we implement YAML configuration ###
if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}

$rubyFolder = '187'
$url = 'http://rubyforge.org/frs/download.php/75679/rubyinstaller-1.8.7-p357.exe'

# $rubyFolder = '192'
# $url = 'http://rubyforge.org/frs/download.php/75127/rubyinstaller-1.9.2-p290.exe'

$rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
$silentArgs = "/silent /dir=`"$rubyPath`""

Install-ChocolateyPackage 'ruby' 'exe' "$silentArgs" "$url"

# Install and configure pik
$rubyBin = join-path $rubyPath 'bin'
$nugetBin = join-path $env:chocolateyinstall 'bin'
$gem = join-path $rubyBin 'gem.bat'
$pikInstall = join-path $rubyBin 'pik_install.bat'
& $gem install pik
& $pikInstall "$nugetBin"

& pik add $rubyBin
& pik use $rubyFolder
