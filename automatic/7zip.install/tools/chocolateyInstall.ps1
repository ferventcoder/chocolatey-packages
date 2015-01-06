Function Get-ExplorerProcessCount
{
  $process = Get-Process explorer -ErrorAction SilentlyContinue
  $processCount = ($process | Measure-Object).Count
  return $processCount
}

try {
  $initialProcessCount = Get-ExplorerProcessCount

  $packageId = '7zip.install'
  $url = '{{DownloadUrl}}'
  $url64 = '{{DownloadUrlx64}}'

  Install-ChocolateyPackage $packageId 'msi' '/quiet' $url $url64

  $finalProcessCount = Get-ExplorerProcessCount

  if($initialProcessCount -lt $finalProcessCount)
  {
    Start-Process explorer.exe
  }

  Write-ChocolateySuccess $packageId
} catch {
  Write-ChocolateyFailure $packageId $($_.Exception.Message)
  throw
}
