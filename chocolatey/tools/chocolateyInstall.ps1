$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)

$modules = Get-ChildItem $toolsPath -Filter *.psm1
$modules | ForEach-Object { import-module -name  $_.FullName }

Initialize-Chocolatey