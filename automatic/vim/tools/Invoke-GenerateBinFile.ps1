# Just a place until this gets included in a chocolatey release.
function Invoke-GenerateBinFile {
param(
  [string] $name,
  [string] $path,
  [string] $outPath,
  [switch] $useStart
)
  Write-Debug "Running 'Invoke-GenerateBinFile' for $name with path:'$path'";

  $packageBatchFileName = Join-Path $outPath "$name.bat"
  $path  = Join-Path $path "$name.exe"
  Write-Host "Adding $packageBatchFileName and pointing to '$path'."
  if ($useStart) {
    Write-Host "Setting up $name as a non-command line application."
"@echo off
SET DIR=%~dp0%
start """" ""$path"" %*" | Out-File $packageBatchFileName -encoding ASCII
  } else {
"@echo off
SET DIR=%~dp0%
""$path"" %*" | Out-File $packageBatchFileName -encoding ASCII
  }
}

