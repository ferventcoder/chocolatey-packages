try {

  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  ### For BinRoot, use the following instead ###
  #$binRoot = "$env:systemdrive\"
  ### Using an environment variable to to define the bin root until we implement configuration ###
  #if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
  #$installDir = Join-Path $binRoot 'instanteyedropper'
  #Write-Host "Adding `'$installDir`' to the path and the current shell path"
  #Install-ChocolateyPath "$installDir"
  #$env:Path = "$($env:Path);$installDir"
  $zipUrl = 'http://instant-eyedropper.com/download/InstantEyedropper.zip'

  Install-ChocolateyZipPackage 'instanteyedropper.portable' "$zipUrl" "$installDir"

  ### OR for 7z ###

  # if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir)}

  # $tempDir = "$env:TEMP\chocolatey\instanteyedropper.portable"
  # if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

  # $file = Join-Path $tempDir "instanteyedropper.portable.7z"
  # Get-ChocolateyWebFile 'instanteyedropper.portable' "$file" "$zipUrl"

  # Start-Process "7za" -ArgumentList "x -o`"$installDir`" -y `"$file`"" -Wait

  Write-ChocolateySuccess 'instanteyedropper.portable'
} catch {
  Write-ChocolateyFailure 'instanteyedropper.portable' "$($_.Exception.Message)"
  throw
}
