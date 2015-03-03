Function Get-ExplorerProcessCount
{
    $process = Get-Process explorer -ErrorAction SilentlyContinue
    $processCount = ($process | Measure-Object).Count
    return $processCount
}

try {
    $initialProcessCount = Get-ExplorerProcessCount

    Install-ChocolateyPackage '7Zip' 'msi' '/quiet' '{{DownloadUrl}}' '{{DownloadUrlx64}}'

    $finalProcessCount = Get-ExplorerProcessCount

    if($initialProcessCount -lt $finalProcessCount)
    {
        Start-Process explorer.exe
    }

    Write-ChocolateySuccess '7Zip'
} catch {
    Write-ChocolateyFailure '7Zip' $($_.Exception.Message)
    throw
}

