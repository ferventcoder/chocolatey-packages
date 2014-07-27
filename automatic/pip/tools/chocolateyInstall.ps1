#import-module C:\Chocolatey\chocolateyInstall\helpers\chocolateyInstaller

function Get-RegistryValue($key, $value) {
  $item = (Get-ItemProperty $key $value -ErrorAction SilentlyContinue)
  if ($item -ne $null) { return $item.$value } else { return $null }
}  

function Get-Python-Home() {
  $result = $null
  
  $filename = Get-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Python.exe" '(default)' 
  
  if ($filename -eq $null) {
    $filename = Get-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Python.exe" '(default)'  
  }
  
  if ($filename -ne $null) {
    $file = Get-ChildItem $filename
    $result = $file.DirectoryName	  
  }
  
  return $result
}


$global:python_home = Get-Python-Home

function CreateFolder ([string]$Path) {
  New-Item -Path $Path -type directory -Force
}

function chocolatey-install() {
    try {
      easy_install pip
      Write-ChocolateySuccess 'pip'
    } catch {
      Write-ChocolateyFailure 'pip' "$($_.Exception.Message)"
      throw 
    }
}

chocolatey-install   
