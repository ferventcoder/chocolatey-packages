try {
  $binRoot = "$env:systemdrive\"

  ### Using an environment variable to to define the bin root until we implement YAML configuration ###
  if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  $devKitInstallDir = join-path $binRoot 'DevKit'

  write-host "Chocolatey is installing DevKit to $devKitInstallDir"
  write-host "Please wait..."
  Start-sleep 3

  if (![System.IO.Directory]::Exists($devKitInstallDir)) {[System.IO.Directory]::CreateDirectory($devKitInstallDir)}
  $tempDir = "$env:TEMP\chocolatey\ruby.devkit"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $file = Join-Path $tempDir "ruby.devkitInstall.exe"
  Get-ChocolateyWebFile 'ruby.devkit' "$file" 'https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe'

  if ($($env:Path).ToLower().Contains("ruby") -eq $false) {
    $env:Path = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine);
  }

  # Preparation
  #If you previously installed the legacy DevKit devkit-3.4.5r3-20091110.7z, its artifacts were extracted into each Ruby installation and need to be manually removed. Remove the gcc.bat, make.bat, and sh.bat stub batch files in <RUBY_INSTALL_DIR>\bin and the <RUBY_INSTALL_DIR>\devkit subdirectory for each Ruby installation using the legacy DevKit.
  $pathItems = $env:Path
  foreach($pathItem in $pathItems -split ";") {
    if ($pathItem -ilike "*ruby*bin") {
      Write-Host "Removing legacy install devkit items from $pathItem if they exist"
      if ([System.IO.File]::Exists("$($pathItem)\gcc.bat")) { Remove-Item "$($pathItem)\gcc.bat" -force}
      if ([System.IO.File]::Exists("$($pathItem)\make.bat")) { Remove-Item "$($pathItem)\make.bat" -force}
      if ([System.IO.File]::Exists("$($pathItem)\sh.bat")) { Remove-Item "$($pathItem)\sh.bat" -force}
      $oldDevKit = Join-Path (Split-Path -Parent $pathItem) 'devkit'
      if ([System.IO.Directory]::Exists("$oldDevKit")) {[System.IO.Directory]::Delete($oldDevKit,$true)}
    }
  }

  # clean out the recommended directories
  # 2. Delete all the <DEVKIT_INSTALL_DIR> subdirectories and files except for config.yml. If you’ve made any customizations to the MSYS shell you may also want to keep files in the etc and home subdirectories.
  if ([System.IO.File]::Exists("$($devKitInstallDir)\config.yml")) {
    Write-Host "Moving config.yml to a holding location prior to extraction"
    Copy-Item "$($devKitInstallDir)\config.yml" "$tempDir" -Force
  }

  if ([System.IO.Directory]::Exists("$($devKitInstallDir)\etc")) {
    Write-Host "Moving etc dir to a holding location prior to extraction"
    if (![System.IO.Directory]::Exists("$($tempDir)\etc")) {[System.IO.Directory]::CreateDirectory("$($tempDir)\etc")}
    Copy-Item "$($devKitInstallDir)\etc\*" "$($tempDir)\etc" -Force -Recurse
  }

  if ([System.IO.Directory]::Exists("$($devKitInstallDir)\home")) {
    Write-Host "Moving home dir to a holding location prior to extraction"
    if (![System.IO.Directory]::Exists("$($tempDir)\home")) {[System.IO.Directory]::CreateDirectory("$($tempDir)\home")}
    Copy-Item "$($devKitInstallDir)\home\*" "$($tempDir)\home" -Force -Recurse
  }

  write-host "Cleaning out the contents of $devKitInstallDir"
  start-sleep 1
  Remove-Item "$($devKitInstallDir)\*" -recurse -force

  # 3. Extract the new SFX DevKit into the same <DEVKIT_INSTALL_DIR> that you just cleaned up.
  write-host "Extracting the contents of $file to $devKitInstallDir"
  start-sleep 3
  #& 7za x -o"$devKitInstallDir" -y "$file"
  Start-Process "7za" -ArgumentList "x -o`"$devKitInstallDir`" -y `"$file`"" -Wait

  if ([System.IO.File]::Exists("$($tempDir)\config.yml")) {
    Write-Host "Moving config.yml back after extraction"
    Copy-Item "$($tempDir)\config.yml" "$devKitInstallDir" -Force
  }

  if ([System.IO.Directory]::Exists("$($tempDir)\etc")) {
    Write-Host "Moving etc dir back after extraction"
    Copy-Item "$($tempDir)\etc\*" "$($devKitInstallDir)\etc" -Force -Recurse
  }

  if ([System.IO.Directory]::Exists("$($tempDir)\home")) {
    Write-Host "Moving home dir back after extraction"
    Copy-Item "$($tempDir)\home\*" "$($devKitInstallDir)\home" -Force -Recurse
  }

  # 4. Review your config.yml file to ensure it contains the root directories of all the installed Rubies you want enhanced to use the DevKit.
  Write-Host "You may want to configure your config.yml after this installation and rerun 'cinst ruby.devkit' if the defaults do not meet your needs"
  Start-Sleep 5
  # 5. From a Command Prompt, cd into the <DEVKIT_INSTALL_DIR> directory and run ruby dk.rb install --force. This will cause all your installed Rubies listed in config.yml to use the updated SFX DevKit when building native gems and update the DevKit’s helper scripts (devkit.rb and operating_system.rb) with any new functionality. For safety, the original helper scripts are timestamp archived beside the new helper scripts. It’s always a good idea to review the two versions (and potentially make modifications) to ensure configuration specific to your system still works as expected.
  Write-Host "Initializing and installing DevKit into Ruby."
  cd $devKitInstallDir
  & ruby dk.rb init
  & ruby dk.rb install --force

  start-sleep 3

  Write-ChocolateySuccess 'ruby.devkit'
} catch {
  Write-ChocolateyFailure 'ruby.devkit' "$($_.Exception.Message)"
  throw
}
