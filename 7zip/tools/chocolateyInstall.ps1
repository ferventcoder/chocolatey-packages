Function Get-ExplorerProcessCount
{
    $process = Get-Process explorer -ErrorAction SilentlyContinue
    $processCount = 0
    if($process -ne $null)
    {
        $processCount = $process.count
    }
    return $processCount
}

try {
    $initialProcessCount = Get-ExplorerProcessCount

    Install-ChocolateyPackage '7Zip' 'msi' '/quiet' 'http://sourceforge.net/projects/sevenzip/files/7-Zip/9.22/7z922.msi' 'http://sourceforge.net/projects/sevenzip/files/7-Zip/9.22/7z922-x64.msi'

    $finalProcessCount = Get-ExplorerProcessCount

    if($initialProcessCount -ne $finalProcessCount)
    {
        Start-Process explorer.exe
    }

    Write-ChocolateySuccess '7Zip'
} catch {
    Write-ChocolateyFailure '7Zip' $($_.Exception.Message)
    throw
}
