Write-Debug ("Starting " + $MyInvocation.MyCommand.Definition)
$scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
Import-Module (Join-Path $scriptDir 'common.ps1')
$fileType = 'msi';
$silentArgs = '/qr /norestart'
$validExitCodes = @(0,1605,3010)
echo "Uninstalling version "$currentinstall.DisplayVersion 
try {
	
	$file = $currentinstall.LocalPackage
	
    
	$msiArgs = "/x $file $silentArgs";
	Start-ChocolateyProcessAsAdmin "$msiArgs" 'msiexec' -validExitCodes $validExitCodes
	
}
catch {

	throw $_.Exception
}
