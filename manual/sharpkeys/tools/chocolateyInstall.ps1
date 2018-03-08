$packageName = 'sharpkeys'
$url         = 'https://github.com/randyrants/sharpkeys/releases/download/v3.6/sharpkeys36.msi'

$packageArgs = @{
    packageName    = $packageName
    fileType       = 'msi'
    url            = $url
    silentArgs     = '/qn'
    validExitCodes = @(0)
    softwareName   = 'SharpKeys'
}

Install-ChocolateyPackage @packageArgs
