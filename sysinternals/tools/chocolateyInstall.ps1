try {
  $packageName = 'sysinternals'
  $url = 'http://download.sysinternals.com/files/SysinternalsSuite.zip'

  $binRoot = Get-BinRoot
  Write-Debug "Bin Root is $binRoot"
  $installDir = Join-Path "$binRoot" "$packageName"


  Install-ChocolateyZipPackage $packageName $url $installDir

  Install-ChocolateyPath $installDir 'User'

  # Delete any existing batch files from an earlier install

  if ($env:chocolateyinstall -ne $null) {
    $nugetBin = join-path $env:chocolateyinstall 'bin'
    $files = get-childitem $installDir -include *.exe -recurse
    foreach ($file in $files) {
      try {
          $batchFile = join-path $nugetBin ($file.Name.Replace(".exe",".bat").Replace(".EXE",".bat"))
          if(test-path $batchFile){
            remove-item $batchFile
        }
      }catch {}
    }
  }
  
  # Add most widely used apps to start menu
  # Pull request 228 not merged yet - https://github.com/chocolatey/chocolatey/pull/228/files - hopefully this is obsolete, because it cannot change the target name.
  # Install-ChocolateyPinnedItem "$installDir\procexp.exe"

  $appData = [environment]::GetFolderPath([environment+specialfolder]::ApplicationData)
  $destPath = Join-Path "$appData" "Microsoft\Windows\Start Menu\Programs\"
  $destLink = Join-Path "$destPath" "Process Explorer.lnk"

  $shell = New-Object -comObject WScript.Shell
  $shortcut = $shell.CreateShortcut($destLink)
  $shortcut.TargetPath = Join-Path "$installDir" "procexp.exe"
  $shortcut.Save()
  
  # You can add more here

  Write-ChocolateySuccess 'sysinternals'
} catch {
  Write-ChocolateyFailure 'sysinternals' $($_.Exception.Message)
  throw
}
