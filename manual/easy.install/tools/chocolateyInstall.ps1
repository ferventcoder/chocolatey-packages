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

  if (($filename -eq $null) -and (Test-Path C:\tools\Python2\python.exe)) {
    $result = "C:\tools\Python2"
  }
  if (($filename -eq $null) -and (Test-Path C:\Python2\python.exe)) {
    $result = "C:\Python2"
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
    # ez_setup.py writes some spam to stderr, so ignore that and rely on exit code
    python $filename 2> $stderr
    if ($LastExitCode -ne 0) {
       throw "Command failed with exit code $LastExitCode."
    }
  }
}

function Install-setuptools($version) {
  Write-Host 'Installing setuptools from http://pypi.python.org/pypi/setuptools ...'

  Python-Exec 'https://bootstrap.pypa.io/ez_setup.py' 'ez_setup.py'

}

function Install-easy-install() {
  Install-setuptools '18.4'
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
    $python_home = Get-Python-Home

    if ($python_home -eq $null) {
      throw 'Python is not installed. easy_install installation aborted!'
    }
  }

  $python_script = Join-Path $python_home 'Scripts'
  Install-ChocolateyPath $python_home 'Machine'
  Install-ChocolateyPath $python_script 'Machine'

  Write-Host "Setting PYTHONHOME environment variable to '$python_home'"
  Install-ChocolateyEnvironmentVariable "PYTHONHOME" $python_home [System.EnvironmentVariableTarget]::Machine
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
  chocolatey-initialize
  Write-Host "Installing easy_install for Python($global:python_version)..."

  Install-easy-install

  $status = Verify-installation

  if (! ($status)) {
    throw "Installation failed! easy_install.exe not found"
  }
}

chocolatey-install # installs easy_install
