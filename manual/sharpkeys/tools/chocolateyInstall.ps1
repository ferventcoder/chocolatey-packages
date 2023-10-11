$packageName = 'sharpkeys'
$url         = 'https://github.com/randyrants/sharpkeys/releases/download/v3.5/sharpkeys35.msi'

$packageArgs = @{
    packageName    = 'sharpkeys'
    fileType       = 'msi'
    url            = $url
    silentArgs     = '/qn'
    validExitCodes = @(0)
    softwareName   = 'SharpKeys'
}

Install-ChocolateyPackage @packageArgs

$installLocation = Get-AppInstallLocation SharpKeys
Install-BinFile -Name SharpKeys -Path (Join-Path $installLocation 'SharpKeys.exe')
