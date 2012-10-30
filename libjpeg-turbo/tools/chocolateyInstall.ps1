try {
  $package = 'libjpeg-turbo'
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
