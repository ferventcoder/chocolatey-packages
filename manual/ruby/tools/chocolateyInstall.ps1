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

  # $checksum = '2e33a098f126275f7cb29ddcd0eb9845'

  # $rubyFolder = '193'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.9.3-p545.exe?direct'
  # $checksum = '05398a6cd920ccd297c28150a935ef72'

  # $rubyFolder = '200'
  # $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p576.exe?direct'
  # $checksum = '723ae8cda24a86c16914582a340deece'
  # $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p576-x64.exe?direct'
  # $checksum64 = 'a6ab3963c571055cba649237d3f4a771'

  $rubyFolder = '213'
  $url = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.3.exe?direct'
  $checksum = 'e5e2c028d76895e9da6c3c86965fc747'
  $url64 = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.3-x64.exe?direct'
  $checksum64 = '0f29131a6852cf92382c082eaf1dfd34'

  $rubyPath = join-path $binRoot $('ruby' + "$rubyFolder")
  $silentArgs = "/verysilent /dir=`"$rubyPath`" /tasks=`"assocfiles,modpath`""

  Install-ChocolateyPackage 'ruby' 'exe' "$silentArgs" "$url" "$url64" #-checksum $checksum -checksum64 $checksum64

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
