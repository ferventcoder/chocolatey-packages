$packageName = 'vagrant'
$url = '{{DownloadUrl}}'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = $url
  silentArgs    = "/qn /norestart /l*v '$env:TEMP\chocolatey\$packageName.install.log'"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
