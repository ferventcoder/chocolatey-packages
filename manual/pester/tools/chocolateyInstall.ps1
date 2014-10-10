try {
  $sysDrive = $env:SystemDrive
  $pesterPath = "$sysDrive\tools\pester"
  if ([System.IO.Directory]::Exists($pesterPath)) {[System.IO.Directory]::Delete($pesterPath,$true)}
  [System.IO.Directory]::CreateDirectory($pesterPath)

  $pesterFiles = Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'pester'

  write-host "Copying the contents of `'$pesterFiles`' to `'$pesterPath`'"
  Copy-Item "$($pesterFiles)\*" $pesterPath -recurse -force

  Install-ChocolateyPath $pesterPath

  write-host 'Pester has been installed. Call runtests from the command line to use Pester. You may need to close and reopen the command shell.'
  Write-ChocolateySuccess 'pester'
} catch {
  Write-ChocolateyFailure 'pester' $($_.Exception.Message)
  throw
}
