$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Attention people from the future. This function will be built into chocolatey 0.9.8.21 or possibly 0.9.8.20
. (Join-Path $scriptDir '.\Invoke-GenerateBinFile.ps1')

$installDir = Split-Path -Parent (Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Vim UninstallString).UninstallString
$binDir = Join-Path (Split-Path -Parent $installDir) 'bin'

if (-not(Test-Path $bindir -PathType Container)) { mkdir $bindir }
Invoke-GenerateBinFile 'gvim' $installDir $binDir -UseStart 
Invoke-GenerateBinFile 'vim' $installDir $binDir


if(-not ($env:PATH.Split(';') -contains $binDir)) {
  Write-Host "Adding $($binDir) to your path"
  $env:PATH = "$($env:PATH);$binDir"
  [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)
}
