function InstallFromLocalOrRemote()
{
    param(
        [Hashtable] $packageArgs,
        [Hashtable] $installArgs
    )

    $packageParameters = ParseParameters $env:chocolateyPackageParameters
    $setupPath = DetermineSetupPath $packageParameters

    # Check for a provided setup executable or ISO
    if ([System.IO.File]::Exists($setupPath)) {
        Write-Host "Installing from: $setupPath"

        $packageArgs['file'] = $setupPath

        Install-ChocolateyInstallPackage @packageArgs
    }
    elseif ([System.IO.File]::Exists($packageArgs['file'])) {
        # Look for a local embedded executable
        
        Write-Host "Installing from: $($packageArgs['file'])"

        Install-ChocolateyInstallPackage @packageArgs
    } 
    elseif ($packageArgs.ContainsKey('url')) {
        # Use The provided URL

        if ($packageArgs.ContainsKey('file')) {
            $packageArgs.Remove('file')
        }

        Write-Host "Downloading Installer: $($packageArgs['url'])"

        Install-ChocolateyPackage @packageArgs
    }
    else {
        throw 'No Installer or Url Provided. Aborting...'
    }

    CleanUp
}

function InstallWithScheduledTaks()
{
    param(
        [Hashtable] $packageArgs
    )

    $packageParameters = ParseParameters $env:chocolateyPackageParameters
    $setupPath = DetermineSetupPath $packageParameters

    # Look for a local embedded executable
    if ([System.IO.File]::Exists($packageArgs['file'])) {
        Write-Host "Installing from: $($packageArgs['file'])"

        StartAsScheduledTask $packageArgs['packageName'] $packageArgs['file'] $packageArgs['silentArgs']
    }
    # Next check for a provided setup executable or ISO
    elseif ([System.IO.File]::Exists($setupPath)) {
        Write-Host "Installing from: $setupPath"

        $packageArgs['file'] = $setupPath

        StartAsScheduledTask $packageArgs['packageName'] $packageArgs['file'] $packageArgs['silentArgs']
    }
    elseif ($packageArgs.ContainsKey('url')) {
        Write-Host "Downloading Installer: $($packageArgs['url'])"

        Get-ChocolateyWebFile `
            -PackageName $packageArgs['packageName'] `
            -FileFullPath $packageArgs['file'] `
            -Url $packageArgs['url']

        StartAsScheduledTask $packageArgs['packageName'] $packageArgs['file'] $packageArgs['silentArgs']
    }
    else {
        throw 'No Installer or Url Provided. Aborting...'
    }

    CleanUp
}

function DetermineSetupPath()
{
    param(
        [Hashtable] $packageParameters
    )

    $isoPath = $packageParameters["iso"]
    $setupPath = $packageParameters["setup"]
    $installerPath = $packageParameters['installer']
    $installerExe = $packageParameters["exe"]

    if ([System.IO.File]::Exists($setupPath)) {
        return $setupPath
    }

    if ([System.IO.File]::Exists($installerPath)) {
        return $installerPath
    }

    if ([System.IO.File]::Exists($isoPath)) {
        Write-Host "ISO: $isoPath"

        $global:mustDismountIso = $true
        $global:isoPath = $isoPath
        $mountedIso = Mount-DiskImage -PassThru $isoPath
        $isoDrive = Get-Volume -DiskImage $mountedIso | Select -expand DriveLetter

        $setupPath = "$isoDrive`:\$installerExe"

        if (![System.IO.File]::Exists($setupPath)) {
            return ''
        }

        return $setupPath
    }

    return $setupPath
}

function ParseParameters([string] $packageParameters)
{
    $arguments = @{}

    if ($packageParameters)
    {
        $match_pattern = "\/(?<option>([a-zA-Z0-9]+))(:|=|-)([`"'])?(?<value>([a-zA-Z0-9- _\\:\.\!\@\#\$\%\^\&\*\(\)+]+))([`"'])?|\/(?<option>([a-zA-Z0-9]+))"
        $option_name = 'option'
        $value_name = 'value'

        if ($packageParameters -match $match_pattern )
        {
            $results = $packageParameters | Select-String $match_pattern -AllMatches

            $results.matches | % {
                $arguments.Add(
                    $_.Groups[$option_name].Value.Trim(),
                    $_.Groups[$value_name].Value.Trim())
            }
        }
        else
        {
          Throw "Package Parameters Were Found but Were Invalid."
        }
    }

    return $arguments
}

function Unzip()
{
    param(
        [string]$file,
        [string] $destination
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($file)

    foreach ($entry in $archive.Entries)
    {
        $entryTargetFilePath = [System.IO.Path]::Combine($destination, $entry.FullName)
        $entryDir = [System.IO.Path]::GetDirectoryName($entryTargetFilePath)

        # Ensure the directory of the archive entry exists
        if(!(Test-Path $entryDir)){
            New-Item -ItemType Directory -Path $entryDir | Out-Null
        }

        # If the entry is not a directory entry, then extract entry
        if(!$entryTargetFilePath.EndsWith("/")){
            try {
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $entryTargetFilePath, $true);
            }
            catch {
                echo $_.Exception.Message
            }
        }
    }
}

function CleanUp([string] $isoPath)
{
    if ($global:mustDismountIso) {
        Dismount-DiskImage -ImagePath $global:isoPath
    }
}

Export-ModuleMember *