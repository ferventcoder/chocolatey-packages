Function Get-ExplorerProcessCount
{
  $process = Get-Process explorer -ErrorAction SilentlyContinue
  $processCount = ($process | Measure-Object).Count
  return $processCount
}

$initialProcessCount = Get-ExplorerProcessCount
Write-Warning "This installer is known to close the explorer process. This means `nyou may lose current work. `nIf it doesn't automatically restart explorer, type 'explorer' on the `ncommand shell to restart it."

$versionMinusDots = "{{PackageVersion}}".Replace(".","")
$packageId = '7zip.install'
$url = "https://sourceforge.net/projects/sevenzip/files/7-Zip/{{PackageVersion}}/7z${versionMinusDots}.exe/download"
$url64 = "https://sourceforge.net/projects/sevenzip/files/7-Zip/{{PackageVersion}}/7z${versionMinusDots}-x64.exe/download"

Install-ChocolateyPackage $packageId 'exe' '/S' $url $url64

$finalProcessCount = Get-ExplorerProcessCount
if($initialProcessCount -lt $finalProcessCount)
{
  Start-Process explorer.exe
}
