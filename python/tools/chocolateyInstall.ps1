try {
    $binRoot = "$env:systemdrive\"

    ### Using an environment variable to to define the bin root until we implement YAML configuration ###
    if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
    $packageName = 'Python'
    $fileType = 'msi'
    $silentArgs = "/qn TARGETDIR=$(join-path $binRoot 'Python27')"
    $url = 'http://www.python.org/ftp/python/2.7.2/python-2.7.2.msi'
    $url64bit = 'http://www.python.org/ftp/python/2.7.2/python-2.7.2.amd64.msi'

    Install-ChocolateyPackage $packageName $fileType $silentArgs $url $url64bit

    Install-ChocolateyPath $(join-path $binRoot 'Python27') 'User'

    $toolsPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
    $parentPath = join-path $toolsPath '..'
    $contentPath = join-path $parentPath 'content'
    $infFile = join-path $contentPath 'PythonScriptIcon.inf'

    # Update the inf file with the content path
    Get-Content $infFile | Foreach-Object{$_ -replace "CONTENT_PATH", "$contentPath"} | Set-Content 'TempFile.txt'
    move-item 'TempFile.txt' $infFile -Force

    # install the inf file
    & rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 $infFile

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
    throw
}
