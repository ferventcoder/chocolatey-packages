$packageName = 'StrawberryPerl'
$fileType = 'MSI'
$binRoot = "$env:systemdrive\"

### Using an environment variable to to define the bin root until we implement YAML configuration ###
if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
$strawberryDir = join-path $binRoot 'strawberry'
$silentArgs = "/qn INSTALLDIR=`"$strawberryDir`""
$url = 'http://strawberryperl.com/download/5.22.0.1/strawberry-perl-5.22.0.1-32bit.msi'
$url64bit = 'http://strawberryperl.com/download/5.22.0.1/strawberry-perl-5.22.0.1-64bit.msi'

Install-ChocolateyPackage $packageName $fileType $silentArgs $url $url64bit
