# MySql Package
$packageName = 'mysql'
$packageType = 'msi'
$silentArgs = '/passive'
$url = 'http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.25-win32.zip'
$url64 = 'http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.25-winx64.zip'


$binRoot = Get-BinRoot
$installDir = Join-Path $binRoot "$packageName"
$installDirBin = "$($installDir)\current\bin"
Write-Host "Adding `'$installDirBin`' to the path and the current shell path"
Install-ChocolateyPath "$installDirBin"
$env:Path = "$($env:Path);$($installDirBin)"


if (![System.IO.Directory]::Exists($installDir)) {[System.IO.Directory]::CreateDirectory($installDir)}

$tempDir = "$env:TEMP\chocolatey\$($packageName)"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

$file = Join-Path $tempDir "$($packageName).zip"
Get-ChocolateyWebFile "$packageName" "$file" "$url" "$url64"

Get-ChocolateyUnzip "$file" "$installDir"

#find this directory
$installedContentsDir = get-childitem $installDir -include 'mysql*' | Sort-Object -Property LastWriteTime -Desc | select -First 1
#shut down service if running
try {
  write-host "Shutting down MySQL if it is running"
  Start-ChocolateyProcessAsAdmin "cmd /c NET STOP MySQL"
  Start-ChocolateyProcessAsAdmin "cmd /c sc delete MySQL"
} catch {
  #no service installed
}

#delete current bin directory contents
if ([System.IO.Directory]::Exists("$installDirBin")) {
  write-host "Clearing out the contents of `'$installDirBin`'"
  start-sleep 3
  [System.IO.Directory]::Delete($installDirBin,$true)
}
#copy the installed directory into the current dir
Write-host "Copying contents of `'$installedContentsDir`' to `'$($installDir)\current`'."
[System.IO.Directory]::CreateDirectory("$installDirBin")
Copy-Item "$($installedContentsDir)\*" "$($installDir)\current" -Force -Recurse
#install the service itself
write-host "Installing the mysql service"
Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --install"
#turn on the service
Start-ChocolateyProcessAsAdmin "cmd /c NET START MySQL"

