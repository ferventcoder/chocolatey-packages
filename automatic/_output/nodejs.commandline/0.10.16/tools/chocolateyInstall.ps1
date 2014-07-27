$packageName = 'nodejs'
$url = 'http://nodejs.org/dist/v0.10.16/node.exe' # download url
$url64 = 'http://nodejs.org/dist/v0.10.16/x64/node.exe' # 64bit URL here or just use the same as $url

try { 
  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 
  ### For BinRoot, use the following instead ###
  #$binRoot = "$env:systemdrive\tools"
  ### Using an environment variable to to define the bin root until we implement configuration ###
  #if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  #$installDir = Join-Path $binRoot "$packageName"
  #Write-Host "Adding `'$installDir`' to the path and the current shell path"
  #Install-ChocolateyPath "$installDir"
  #$env:Path = "$($env:Path);$installDir"

  $nodePath = Join-Path $installDir 'node.exe'
  Get-ChocolateyWebFile "$packageName" "$nodePath" "$url" "$url64"

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}