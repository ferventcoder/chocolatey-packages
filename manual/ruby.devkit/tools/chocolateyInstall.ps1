$id = "ruby.devkit"
$url = "https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe"

$tools = Split-Path $MyInvocation.MyCommand.Definition
$devkit = Join-Path (Get-BinRoot) "DevKit"
$temp = Join-Path $ENV:TEMP (Join-Path "chocolatey" $id)

. (Join-Path $tools "rubydevkit.ps1")

try {
  New-Item $temp -Type "Directory" -Force | Out-Null

  # If you previously installed the legacy DevKit devkit-3.4.5r3-20091110.7z, 
  # its artifacts were extracted into each Ruby installation and need to be 
  # manually removed. Remove the gcc.bat, make.bat, and sh.bat stub batch files 
  # in <RUBY_INSTALL_DIR>\bin and the <RUBY_INSTALL_DIR>\devkit subdirectory 
  # for each Ruby installation using the legacy DevKit.
  Get-Rubies | %{ 
    Write-Host "[$id] Removing legacy devkit at: $_"
    Remove-RubyDevkitLegacy $_ 
  }  

  # Delete all the <DEVKIT_INSTALL_DIR> subdirectories and files except for 
  # config.yml. If you’ve made any customizations to the MSYS shell you may 
  # also want to keep files in the etc and home subdirectories.
  Backup-RubyDevkitCustomizations $devkit $temp
  Remove-RubyDevkit $devkit
  
  Install-ChocolateyZipPackage $id $url $devkit
  
  Restore-RubyDevkitCustomizations $devkit $temp
  
  # Review your config.yml file to ensure it contains the root directories of 
  # all the installed Rubies you want enhanced to use the DevKit.
  Write-Host "[$id] You may change config.yml and reinstall this package using the -force switch"
  
  # From a Command Prompt, cd into the <DEVKIT_INSTALL_DIR> directory and run 
  # ruby dk.rb install --force. This will cause all your installed Rubies 
  # listed in config.yml to use the updated SFX DevKit when building native 
  # gems and update the DevKit’s helper scripts (devkit.rb and 
  # operating_system.rb) with any new functionality. For safety, the original 
  # helper scripts are timestamp archived beside the new helper scripts. It’s 
  # always a good idea to review the two versions (and potentially make 
  # modifications) to ensure configuration specific to your system still works 
  # as expected.
  Write-Host "[$id] Initializing and installing: $devkit"
  Install-RubyDevkit $devkit

  Write-ChocolateySuccess $id
} catch {
  Write-ChocolateyFailure $id $_.Exception.Message
  throw
}
