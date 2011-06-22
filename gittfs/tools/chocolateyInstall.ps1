try {
  #$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $sysDrive = $env:SystemDrive
  $gittfsPath = "$sysDrive\tools\gittfs"
  if (![System.IO.Directory]::Exists($gittfsPath)) {[System.IO.Directory]::CreateDirectory($gittfsPath)}
  
  Install-ChocolateyZipPackage 'gittfs' 'https://github.com/downloads/spraints/git-tfs/GitTfs-0.11.0.zip' $gittfsPath

  #------- ADDITIONAL SETUP -------#
  #add it to the path
  $envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
  if (!$envPath.ToLower().Contains($gittfsPath.ToLower()))
  {
    Write-Host "PATH environment variable does not have $gittfsPath in it. Adding..."

    $statementTerminator = ";"
    #does the path end in ';'?
    $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator) {$gittfsPath = $statementTerminator + $gittfsPath}
    $envPath = $envPath + $gittfsPath + $statementTerminator

    [Environment]::SetEnvironmentVariable('Path', $envPath, [System.EnvironmentVariableTarget]::Machine)
  }

  write-host 'git-tfs has been installed. Call git tfs from the command line to see options. You may need to close and reopen the command shell.'
  Write-ChocolateySuccess 'gittfs'
} catch {
  Write-ChocolateyFailure 'gittfs' $($_.Exception.Message)
  throw 
}