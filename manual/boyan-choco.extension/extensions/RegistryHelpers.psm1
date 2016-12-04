function Test-RegistryValue
{
    param (
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] $path,
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] $value
    )

    try
    {
        if (Test-Path -Path $Path)
        {
            Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
            return $true
        }
    }
    catch
    {
        return $false
    }
}