# MySql Package
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName = 'mysql'
$packageType = 'msi'
$silentArgs = '/passive'
$url = 'https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18-win32.zip'
$url64 = 'https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18-winx64.zip'

$binRoot = Get-BinRoot
$installDir = Join-Path $binRoot "$packageName"
$installDirBin = "$($installDir)\current\bin"
Write-Host "Adding `'$installDirBin`' to the path and the current shell path"
Install-ChocolateyPath "$installDirBin"
$env:Path = "$($env:Path);$($installDirBin)"


if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir) | Out-Null}

$tempDir = "$env:TEMP\chocolatey\$($packageName)"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir) | Out-Null}

$file = Join-Path $tempDir "$($packageName).zip"
Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"

Get-ChocolateyUnzip "$file" "$installDir"

# find the unpack directory
$installedContentsDir = get-childitem $installDir -include 'mysql*' | Sort-Object -Property LastWriteTime -Desc | select -First 1
# shut down service if running
try {
  write-host "Shutting down MySQL if it is running"
  Start-ChocolateyProcessAsAdmin "cmd /c NET STOP MySQL"
  Start-ChocolateyProcessAsAdmin "cmd /c sc delete MySQL"
} catch {
  # no service installed
}

# delete current bin directory contents
if ([System.IO.Directory]::Exists("$installDirBin")) {
  write-host "Clearing out the contents of `'$installDirBin`'."
  start-sleep 3
  [System.IO.Directory]::Delete($installDirBin,$true)
}

# copy the installed directory into the current dir
Write-host "Copying contents of `'$installedContentsDir`' to `'$($installDir)\current`'."
[System.IO.Directory]::CreateDirectory("$installDirBin") | Out-Null
Copy-Item "$($installedContentsDir)\*" "$($installDir)\current" -Force -Recurse

$iniFileDest = "$($installDir)\current\my.ini"
if (!(Test-Path($iniFileDest))) {
  Write-Host "No existing my.ini. Creating default '$iniFileDest' with default locations for datadir."
  
@"
[mysqld]
basedir=$($installDir.Replace("\","\\"))\\current
datadir=C:\\ProgramData\\MySQL\\data
"@ | Out-File $iniFileDest -Force -Encoding ASCII
}

# initialize everything
# https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization-mysqld.html
Write-Host "Initializing mysql if it hasn't already been initialized."
try {

  $defaultDataDir='C:\ProgramData\MySQL\data'
  if (![System.IO.Directory]::Exists($defaultDataDir)) {[System.IO.Directory]::CreateDirectory($defaultDataDir) | Out-Null}
  Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --defaults-file=$iniFileDest --initialize-insecure"
} catch {
  write-host "MySQL has already been initialized"
}

# install the service itself
write-host "Installing the mysql service"
Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --install"
# turn on the service
Start-ChocolateyProcessAsAdmin "cmd /c NET START MySQL"

