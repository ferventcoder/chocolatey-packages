param($installPath, $toolsPath, $package, $project)

$modules = Get-ChildItem $ToolsPath -Filter *.psm1
$modules | ForEach-Object { import-module -name  $_.FullName }

@"
========================
NuGet Package Folder Override
========================
Please run Install-NuGetPackageFolderOverride "[optionalRelativePathFromSolution]" (defaults to lib)
If you already have packages installed, you may want to reinstall them after you run.
To uninstall, run Remove-NuGetPackageFolderOverride
========================
"@ | Write-Host