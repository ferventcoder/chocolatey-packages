
function Install {
param(
    [string] $packageName,
    [string] $url,
    [string] $checksum
)
    $installerType = 'exe'
    $validExitCodes = @(0)
    $silentArgs = '/S'
    $checksumType = 'sha256';

    Install-ChocolateyPackage $packageName `
        $installerType `
        $silentArgs `
        $url `
        $url `
        -validExitCodes $validExitCodes `
        -Checksum64 "$checksum" `
        -ChecksumType64 $checksumType `
        -ChecksumType "$checksumType" `
        -Checksum "$checksum"
}

Export-ModuleMember *