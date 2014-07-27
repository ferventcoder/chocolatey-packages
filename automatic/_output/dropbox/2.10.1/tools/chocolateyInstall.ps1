$packageName = 'dropbox'
$version = '2.10.1'
$uninstallRegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Dropbox'
$filePath = "$env:TEMP\chocolatey\$packageName"
$fileFullPath = "$filePath\${packageName}Install.exe"
$url = 'https://dl-web.dropbox.com/u/17/Dropbox 2.10.1.exe'

$fileType = 'exe'
$silentArgs = '/S'

# Variables for the AutoHotkey-script
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$ahkFile = "$scriptPath\dropbox.ahk"
 
try {

	if (Test-Path $uninstallRegistryPath) {
		$installedVersion = (Get-ItemProperty $uninstallRegistryPath).DisplayVersion
	}

	if ($installedVersion -eq $version) {
		Write-Host "Dropbox $version is already installed."
	} else {

        # Download and install Dropbox

		if (-not (Test-Path $filePath)) {
			New-Item $filePath -type directory
		}

		Get-ChocolateyWebFile $packageName $fileFullPath $url
		Start-Process 'AutoHotkey' $ahkFile
		Start-Process $fileFullPath $silentArgs
		Wait-Process -Name "dropboxInstall"
		Remove-Item $fileFullPath
	}

	Write-ChocolateySuccess $packageName

} catch {

	Write-ChocolateyFailure $packageName $($_.Exception.Message)
	throw
}
