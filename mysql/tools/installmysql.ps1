$packageName = 'mysql'
$packageType = 'msi'
$silentArgs = '/passive'
$downloadUrl = 'http://cdn.mysql.com/Downloads/MySQLInstaller/mysql-installer-community-{{PackageVersion}}.msi'

try {
  Install-ChocolateyPackage "$packageName" "$packageType" "$silentArgs" "$downloadUrl"
  
  #------- ADDITIONAL SETUP -------#
  #add it to the path
  $mysqlPath = "$env:SystemDrive\Program Files\MySQL\MySQL Server 5.6\bin"
  if (![System.IO.Directory]::Exists($mysqlPath)) {$mysqlPath = "$env:SystemDrive\Program Files (x86)\MySQL\MySQL Server 5.6\bin";}
  Install-ChocolateyPath $mysqlPath 'Machine'

  #install the service itself
  Start-Process -FilePath "$mysqlPath\mysqld" -ArgumentList '--install' -Wait -NoNewWindow
  #turn on the service
  Start-Process -FilePath "NET" -ArgumentList 'START MySQL' -Wait -NoNewWindow
  
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" $($_.Exception.Message)
  throw 
}