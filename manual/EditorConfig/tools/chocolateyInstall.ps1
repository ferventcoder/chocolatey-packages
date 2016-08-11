#some code "borrowed" from
#https://raw.github.com/alanstevens/ChocoPackages/master/alanstevens.vsextensions/tools/ChocolateyInstall.ps1
$packageName = 'EditorConfig'

#look for all VS2010 and 2012
$installers = @('HKCU:\Software\Microsoft\VisualStudio\10.0_Config',
  'HKCU:\Software\Microsoft\VisualStudio\11.0_Config') |
  ? { Test-Path $_ } |
  % {
    $installerPath = (Get-ItemProperty "$($_)\Setup\VS").EnvironmentDirectory
    Join-Path $installerPath 'vsixinstaller.exe'
  } |
  ? { Test-Path $_ }

try
{
  $tempDir = "$env:TEMP\chocolatey\editorConfig"
  if (!(Test-Path $tempDir)) { New-Item $tempDir -Type Directory }

  $params = @{
    packageName = $packageName;
    fileFullPath = Join-Path $tempDir "EditorConfigPlugin-0.2.6.vsix";
    url = 'https://visualstudiogallery.msdn.microsoft.com/c8bccfe2-650c-4b42-bc5c-845e21f96328/file/75539/7/EditorConfigPlugin-0.2.6.vsix';
  }

  Get-ChocolateyWebFile @params

  $installers |
    % {
      Write-Host "Installing `'$($params.fileFullPath)`' with $_"
      $vsParams = '/q', $params.fileFullPath
      &$_ $vsParams | Out-Null
    }

  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
  throw
}

