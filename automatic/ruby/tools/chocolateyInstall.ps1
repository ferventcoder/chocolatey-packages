try {

  $packageName = '{{PackageName}}'
  $version = '{{PackageVersion}}'
  # The original \{\{DownloadUrlx64\}\} variable is “misused” as hash table
  # that contains the 64-bit URL, and both MD5 checksums for 32- and 64-bit
  $installerProps = {{DownloadUrlx64}}

  # Calculate $binRoot
  $binRoot = Get-BinRoot

  $versionHash = [version]$version
  $rubyFolder = $([string]$versionHash.Major + [string]$versionHash.Minor + [string]$versionHash.Build)
  $url = '{{DownloadUrl}}'
  $checksum = $installerProps.md5sum32
  $url64 = $installerProps.url64
  $checksum64 = $installerProps.md5sum64

  $rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
  $silentArgs = "/verysilent /dir=`"$rubyPath`" /tasks=`"assocfiles,modpath`""

  Install-ChocolateyPackage "$packageName" 'exe' "$silentArgs" "$url" "$url64" #-checksum $checksum -checksum64 $checksum64

  $rubyBin = join-path $rubyPath 'bin'
  Write-Host "Adding `'$rubyBin`' to the local path"
  $env:Path = "$($env:Path);$rubyBin"

  # # Install and configure pik
  # Write-Host "Now we are going to install pik and set up the folder - so Ruby is pointed to the correct version"
  # $nugetBin = join-path $env:ChocolateyInstall 'bin'
  # #$gem = 'gem.bat'
  # $pikInstall = 'pik_install.bat'
  # & gem install pik
  # & $pikInstall "$nugetBin"

  # & pik add $rubyBin
  # & pik use $rubyFolder

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" $($_.Exception.Message)
  throw
}
