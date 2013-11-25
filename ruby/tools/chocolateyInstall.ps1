try {

  # Temporary include function until it is included with Chocolatey

  $thisDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  if (!(Get-Command Get-BinRoot -errorAction SilentlyContinue))
  {
    Import-Module "$($thisDir)\Get-BinRoot.ps1"
  }

  # Calculate $binRoot
  $binRoot = Get-BinRoot

  # $rubyFolder = '187'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.8.7-p374.exe?direct'

  # $rubyFolder = '193'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.9.3-p484.exe?direct'

  $rubyFolder = '200'
  $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p353.exe?direct'
  $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p353-x64.exe?direct'

  $rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
  $silentArgs = "/verysilent /dir=`"$rubyPath`" /tasks=`"assocfiles,modpath`""

  #Install-ChocolateyPackage 'ruby' 'exe' "$silentArgs" "$url"
  Install-ChocolateyPackage 'ruby' 'exe' "$silentArgs" "$url" "$url64"

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

  Write-ChocolateySuccess 'ruby'
} catch {
  Write-ChocolateyFailure 'ruby' $($_.Exception.Message)
  throw
}
