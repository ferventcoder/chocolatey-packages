#try { 
  #& gem install pik
  #$chocoBin = join-path $env:ChocolateyInstall 'bin'
  #& pik_install "$chocoBin"
  
  # Temporary include function until it is included with Chocolatey
  Import-Module "$($pwd)\Get-BinRoot.ps1"
    
  # Get $binRoot until we implement YAML configuration
  $binRoot = Get-BinRoot
  $pikPath = join-path $binRoot 'pik'
  
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $logFile = Join-Path $scriptDir 'pikinstall.log'

  Install-ChocolateyPackage 'pik' 'msi' "/quiet /norestart INSTALLDIR=$pikPath /l*v $logFile" 'https://github.com/downloads/vertiginous/pik/pik-0.2.8.msi' #  -validExitCodes @(0)
  
  Write-Host "Now you just need to call `'pik add Ruby_Install_Bin_Dir`' followed by `'pik use Ruby_Version_Number`'"
  Write-Host "For example, if you had ruby installed at C:\Ruby192, you would call `'pik add C:\Ruby192\bin`' followed by `'pik use 192`'"
  Write-Host "You may need to close and reopen the command line first prior to calling pik"
  #& pik add $rubyBin
  #& pik use $rubyFolder

#  Write-ChocolateySuccess 'pik'
#} catch {
#  Write-ChocolateyFailure 'pik' "$($_.Exception.Message)"
#  throw 
#}
