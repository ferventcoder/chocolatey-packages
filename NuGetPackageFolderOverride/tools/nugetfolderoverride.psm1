function Install-NuGetPackageFolderOverride {
param([string] $packagesFolder = "lib")
	$solutionFolder = $PWD
	$nugetConfig = Join-Path $solutionFolder 'nuget.config'

@"
<settings>
<repositoryPath>$packagesFolder</repositoryPath>
</settings>
"@ | Out-File $nugetConfig

#	$packageOverrideFolder = Get-ChildItem "$solutionFolder" -recurse | ?{$_.name -match "nugetpackagefolderoverride*"} | sort name | select -First 1 
#	if ($packageOverrideFolder -notlike '') {
#		$newPkgFolder = join-path $PWD $packageOverrideFolder 
#		#create the base structure if it doesn't exist
#  	if (![System.IO.Directory]::Exists($nugetExePath)) {[System.IO.Directory]::CreateDirectory($newPkgFolder)}
#		Write-Host "Moving NuGetPackageFolderOverride folder over to $newPkgFolder from $thisScriptFolder"
#		Copy-Item "$($packageOverrideFolder.FullName)" "$($newPkgFolder.FullName)" -force
#	}

@"
The $nugetConfig file has been added. 
Please close and restart visual studio.
"@ | write-host
}

function Remove-NuGetPackageFolderOverride {
	$solutionFolder = $PWD
	$nugetConfig = Join-Path $solutionFolder 'nuget.config'
	Remove-Item $nugetConfig
@"
The $nugetConfig file has been removed. 
Please close and restart visual studio.
"@ | write-host
}

export-modulemember -function Install-NuGetPackageFolderOverride;
export-modulemember -function Remove-NuGetPackageFolderOverride;