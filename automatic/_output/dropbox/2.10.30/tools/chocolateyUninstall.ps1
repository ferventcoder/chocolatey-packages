try {

    $packageName = 'dropbox'
    $fileType = 'exe'
    $silentArgs = '/S'
    $uninstallerPath = Join-Path $env:APPDATA 'Dropbox\bin\DropboxUninstaller.exe'
    
    if (Test-Path $uninstallerPath) {
        Uninstall-ChocolateyPackage $packageName $fileType $silentArgs $uninstallerPath
    }

    Write-ChocolateySuccess $packageName

} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
