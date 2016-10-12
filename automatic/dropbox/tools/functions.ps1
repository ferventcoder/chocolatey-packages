Function getDropboxRegProps() {
  $uninstallRegistryPath = 'HKLM:\Software' + $bitness + '\Microsoft\Windows\CurrentVersion\Uninstall\Dropbox'
  $bitness = @{$true = "\WOW6432Node"; $false = ""}[ (Get-ProcessorBits) -eq 64 ]

  if (Test-Path $uninstallRegistryPath) {
    $props = @{
      "DisplayVersion" = (Get-ItemProperty $uninstallRegistryPath).DisplayVersion
      "UninstallString" = (Get-ItemProperty $uninstallRegistryPath).UninstallString
    }
  }

  return $props
}
