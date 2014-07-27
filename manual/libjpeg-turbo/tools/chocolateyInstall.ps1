try {
  $package = 'libjpeg-turbo'

  #http://sourceforge.net/mailarchive/forum.php?thread_name=AANLkTimNeXmdjqowHzq2tF01%2BaDS2GXW9fTUwdG-cW%2B1%40mail.gmail.com&forum_name=libjpeg-turbo-users
  # must delete turbojpeg.dll to "upgrade"
  $dll = 'turbojpeg.dll'

  @('System', 'SystemX86') |
    ? { [Enum]::IsDefined([Environment+SpecialFolder], $_) } |
    % { Join-Path ([Environment]::GetFolderPath($_)) $dll} |
    # ensure we're trying to delete just a file (safety check)
    ? { (Test-Path $_) -and (!(Get-Item $_).PsIsContainer) } |
    % {
      Write-Host "Removing existing file $_"
      Remove-Item $_
    }

  #uses NSIS installer
  Install-ChocolateyPackage 'libjpeg-turbo' 'exe' '/S' `
    'http://sourceforge.net/projects/libjpeg-turbo/files/1.2.1/libjpeg-turbo-1.2.1-vc.exe/download' `
    'http://sourceforge.net/projects/libjpeg-turbo/files/1.2.1/libjpeg-turbo-1.2.1-vc64.exe/download'

  $systemDrive = [Environment]::GetEnvironmentVariable('SystemDrive')
  $installPath = @('libjpeg-turbo64', 'libjpeg-turbo') |
    % { Join-Path (Join-Path $systemDrive $_) 'bin' } |
    ? { Test-Path $_ } |
    Select -First 1

  Install-ChocolateyPath $installPath

  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
