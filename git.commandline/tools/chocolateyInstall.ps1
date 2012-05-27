try {
  $binRoot = "$env:systemdrive\"

  ### Using an environment variable to to define the bin root until we implement YAML configuration ###
  if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  $gitInstallDir = join-path $binRoot 'git'

  write-host "Chocolatey is installing git to $gitInstallDir"
  write-host "Please wait..."
  Start-sleep 3

  if (![System.IO.Directory]::Exists($gitInstallDir)) {[System.IO.Directory]::CreateDirectory($gitInstallDir)}
  $tempDir = "$env:TEMP\chocolatey\git.commandline"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $file = Join-Path $tempDir "git.7z"
  #Get-ChocolateyWebFile 'git' "$file" 'http://msysgit.googlecode.com/files/PortableGit-1.7.10-preview20120409.7z'
  Get-ChocolateyWebFile 'git' "$file" '{{DownloadUrl}}'

  write-host "Cleaning out the contents of $gitInstallDir"
  Remove-Item "$($gitInstallDir)\*" -recurse -force

  write-host "Extracting the contents of $file to $gitInstallDir"
  #& 7za x -o"$gitInstallDir" -y "$file"
  Start-Process "7za" -ArgumentList "x -o`"$gitInstallDir`" -y `"$file`"" -Wait

  Install-ChocolateyPath $gitInstallDir 'user'
  Install-ChocolateyPath "$($gitInstallDir)\cmd" 'user'
  
  Write-Host 'Making GIT core.autocrlf false'
  #make GIT core.autocrlf false
  & "$env:comspec" '/c git config --global core.autocrlf false'

  Write-ChocolateySuccess 'git.commandline'
} catch {
  Write-ChocolateyFailure 'git.commandline' $($_.Exception.Message)
  throw
}
