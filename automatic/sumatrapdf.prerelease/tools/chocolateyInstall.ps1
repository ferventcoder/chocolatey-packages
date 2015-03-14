$ProcessActive = Get-Process sumatraPDF* -ErrorAction SilentlyContinue
if($ProcessActive -ne $null)
{
    Stop-Process -ProcessName sumatraPDF*
}
Install-ChocolateyPackage '{{PackageName}}' 'exe' '/S' '{{DownloadUrl}}' -validExitCodes @(0)