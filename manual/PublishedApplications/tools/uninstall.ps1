param($installPath, $toolsPath, $package, $project)

$targetImport = ".\targets\Microsoft.Application.targets"
Write-Host 'Removing msbuild import of '$targetImport ' to ' $project.Object.Project.Name

[Reflection.Assembly]::LoadWithPartialName("Microsoft.Build")
$vsProject = [Microsoft.Build.Construction.ProjectRootElement]::Open($project.Object.project.FullName)

foreach ($child in $vsProject.AllChildren)
{
    if ($child.GetType().ToString() -eq "Microsoft.Build.Construction.ProjectImportElement")
    {
        $import = [Microsoft.Build.Construction.ProjectImportElement]$child
        if ($import.Project -eq $targetImport)
        {
            $vsProject.RemoveChild($child)
        }
        else
        {
            Write-Host $import.Project
        }
    }
}

$vsProject.Save()
