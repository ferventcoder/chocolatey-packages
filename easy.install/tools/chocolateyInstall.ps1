#import-module C:\Chocolatey\chocolateyInstall\helpers\chocolateyInstaller

$global:python_home = $null
$global:python_version = $null

function _cmd($command) {
  $result = cmd.exe /c "$command 2>&1" #stderr hack  
  return $result
}

function Get-RegistryValue($key, $value) {
  $item = (Get-ItemProperty $key $value -ErrorAction SilentlyContinue)
  if ($item -ne $null) { return $item.$value } else { return $null }
}  

function Get-Python-Home() {
  #envs: PYTHONHOME and PYTHON_HOME
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

function Get-Python-Version() {
  $res = _cmd 'python -V' # Python 2.7.3
  
  if ($res -ne $null) {
	return $res.Replace('Python', '').Trim()
  }
  
  return $null  
}

function is64bit() {
  return ([IntPtr]::Size -eq 8)
}

function Python-Exec($url, $name) {
  # _cmd "cd /d %TEMP% && curl -O $url && python $name" #old way
  
  $filename = Join-Path $env:TEMP $name
  Get-ChocolateyWebFile 'easy.install' $filename $url
  
  if (has_file $filename) {
    Write-Host "Running python file: '$filename'"
    python $filename
  }  
}

function Install-setuptools($version) {
  Write-Host 'Installing setuptools from http://pypi.python.org/pypi/setuptools ...'
  $pyvrs = $global:python_version.substring(0, 3) #2.7.3 >> 2.7
  
  if (is64bit) {
    Python-Exec 'http://peak.telecommunity.com/dist/ez_setup.py' 'ez_setup.py'
  }
  else {  
    # http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11.win32-py2.7.exe
	$url = "http://pypi.python.org/packages/$pyvrs/s/setuptools/setuptools-$version.win32-py$pyvrs.exe"
	Install-ChocolateyPackage 'easy.install/setuptools' 'exe' '/S' $url	
  }
}

function Install-distribute() {	  
  Write-Host 'Installing distribute, Distribute is a fork of the Setuptools project. works with python versions >= 3.0'
  Write-Host 'distribute homepage: http://pypi.python.org/pypi/distribute'
  Python-Exec 'http://python-distribute.org/distribute_setup.py' 'distribute_setup.py'
}

function Install-easy-install() {
   $pyvrs = [int]$global:python_version.Replace('.', '').substring(0, 2) # 27

	if ($pyvrs -gt 27) {
      Install-distribute
	}
	else {
	  Install-setuptools '0.6c11'  
	}	  
}  

function has_file($filename) {
  return Test-Path $filename
} 

function Verify-installation() {
  return has_file (Join-Path $global:python_home 'Scripts\easy_install.exe')
}

function setup-python() {
  $python_home = Get-Python-Home

  if ($python_home -eq $null) {    
    Write-Host "Installing Python using chocolatey. Wait..."
    cinst python    
  
    $python_home = Get-Python-Home
  
    if ($python_home -eq $null) {
      throw 'Python is not installed. easy_install installation aborted!'
    }
  }    
  
  $python_script = Join-Path $python_home 'Scripts'
  Install-ChocolateyPath $python_home 'User'
  Install-ChocolateyPath $python_script 'User'
  
  Write-Host "Setting PYTHONHOME environment variable to '$python_home'"
  Write-Host "PS: PYTHONHOME variable is not required to Python works, but it is a good practice to have it."
  [Environment]::SetEnvironmentVariable('PYTHONHOME', $python_home, 'User')  
  $Env:PYTHONHOME = $python_home
  
  return $python_home
}

function chocolatey-initialize() {
  $global:python_home = setup-python
  
  Write-Host "Using python home at '$global:python_home'"

  $global:python_version = Get-Python-Version

  if ($global:python_version -eq $null) {
    throw "Python Version could not be found. Executing 'python -V' at prompt works?"
  }
}  

function chocolatey-install() {
	try {
        chocolatey-initialize
	    Write-Host "Installing easy_install for Python($global:python_version)..."
	
		Install-easy-install
        
        $status = Verify-installation
        
        if ($status) {
		  Write-ChocolateySuccess 'easy.install'
        }  
	
	} catch {
	  Write-ChocolateyFailure 'easy.install' "$($_.Exception.Message)"
	  throw 
	}
}

chocolatey-install # installs easy_install


