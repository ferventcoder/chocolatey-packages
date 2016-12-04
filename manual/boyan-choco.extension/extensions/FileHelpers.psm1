function GetCurrentDirectory([string] $scriptDirectory)
{
    return $(Split-Path -parent $scriptDirectory)
}

function GetParentDirectory([string] $scriptDirectory)
{
    return Join-Path -Resolve $(Split-Path -parent $scriptDirectory) ..
}

function GetProgramFilesDirectory()
{
    $programFiles = @{$true = "$env:programFiles (x86)"; $false = $env:programFiles}[64 -Match (get-processorBits)]

    return $programFiles
}

function GetConfigurationFile()
{
    param(
        [string] $configuration,
        [string] $defaultConfiguration
    )

    if ([System.IO.File]::Exists($configuration))
    {
        return $configuration
    }

    if (($configuration -as [System.URI]).AbsoluteURI -ne $null)
    {
        $localConfiguration = Join-Path $env:Temp 'Configuration.xml'

        if (Test-Path $localConfiguration)
        {
            Remove-Item $localConfiguration
        }

        Get-ChocolateyWebFile 'ConfigurationFile' $localConfiguration $configuration | Out-Null

        return $localConfiguration
    }

    return $defaultConfiguration
}