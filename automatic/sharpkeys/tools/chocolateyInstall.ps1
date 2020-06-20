$packageArgs = @{
    packageName    = 'sharpkeys'
    fileType       = 'msi'
    url            = ''
    checksum       = ''
    checksumType   = ''
    silentArgs     = '/qn'
    validExitCodes = @(0)
    softwareName   = 'SharpKeys'
}

Install-ChocolateyPackage @packageArgs
