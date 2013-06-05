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

$extras = @{
  'name' = 'virtualenv';
  'description' = 'virtualenv is a tool to create isolated Python environments';
  'url' = 'http://www.virtualenv.org';
  'block' = {
     $workon_home = Join-Path $env:USERPROFILE '.virtualenvs'
     CreateFolder $workon_home
     [Environment]::SetEnvironmentVariable('PIP_RESPECT_VIRTUAL_ENV', 'true', "User")
     [Environment]::SetEnvironmentVariable('PIP_VIRTUALENV_BASE', $workon_home, "User")
     [Environment]::SetEnvironmentVariable('WORKON_HOME', $workon_home, "User")
  }	
}, @{
  'name' = 'fabric';
  'description' = 'Fabric is a library and command-line tool for streamlining the use of SSH for application deployment or systems administration tasks';
  'url' = 'http://fabfile.org'
}, @{
  'name' = 'ipython';
  'description' = 'IPython provides a rich toolkit to help you make the most out of using Python';
  'url' = 'http://ipython.org'  
}, @{
   'name' = 'django';
   'description' = 'Django is a high-level Python Web framework';
   'url' = 'https://www.djangoproject.com';
   'block' = {
     $django_bin = Join-Path $global:python_home 'lib\site-packages\django\bin'
     Install-ChocolateyPath $django_bin 'User'
  }
}  

# @{'name'= 'buildout'; 'url' = 'http://www.buildout.org'; 'package' =  'zc.buildout' }
# https://www.djangoproject.com' pip install -g Django

function CreateFolder ([string]$Path) {
  New-Item -Path $Path -type directory -Force
}

function install-extras() {
  Write-Host "Installing default packages"
    $extras | ForEach-Object { 
      $name = $_.name
      $url = $_.url
      $description = $_.description      
      $package = if ($_.ContainsKey('package')) { $_.package } else { $name }
      $block = if ($_.ContainsKey('block')) { $_.block } else { $null }
      
      $cmd = "pip install $package" # pip install -g $package
      Write-Host "Installing package '$name'
      description: $description
      url: $url
      wait..."
      Write-Host $cmd 
      iex $cmd   
      
      if ($block -ne $null) {
        &$block
      }
      
      Write-Host ""      
    }  
}

function chocolatey-install() {
    try {
      easy_install pip
      install-extras        
     
      Write-ChocolateySuccess 'pip'
    } catch {
      Write-ChocolateyFailure 'pip' "$($_.Exception.Message)"
      throw 
    }
}

chocolatey-install   
