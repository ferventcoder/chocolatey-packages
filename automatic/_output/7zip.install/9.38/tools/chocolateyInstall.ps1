Function Get-ExplorerProcessCount
{
  $process = Get-Process explorer -ErrorAction SilentlyContinue
  $processCount = ($process | Measure-Object).Count
  return $processCount
}

$initialProcessCount = Get-ExplorerProcessCount

Write-Warning "This installer is known to close the explorer process. This means `nyou may lose current work. `nIf it doesn't automatically restart explorer, type 'explorer' on the `ncommand shell to restart it."


$packageId = '7zip.install'
$url = 'http://www.7-zip.org/a/7z938.msi'
$url64 = 'http://www.7-zip.org/a/7z938-x64.msi'

Install-ChocolateyPackage $packageId 'msi' '/quiet' $url $url64

$finalProcessCount = Get-ExplorerProcessCount

if($initialProcessCount -lt $finalProcessCount)
{
  Start-Process explorer.exe
}
