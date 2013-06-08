$packageName = 'mysql'
$packageType = 'msi'
$silentArgs = '/passive'
$downloadUrl = "http://cdn.mysql.com/Downloads/MySQLInstaller/mysql-installer-community-{{PackageVersion}}.msi"

#$downloadUrl64 = ""

#http://www.mysql.com/get/Downloads/MySQL-5.5/mysql-{{PackageVersion}}-win32.msi/from/http://mysql.he.net/' 
#'http://www.mysql.com/get/Downloads/MySQL-5.5/mysql-{{PackageVersion}}-winx64.msi/from/http://mysql.he.net/'

try {
  Install-ChocolateyPackage "$packageName" "$packageType" "$silentArgs" "$downloadUrl" #"$downloadUrl64"
  
  #------- ADDITIONAL SETUP -------#
  #add it to the path
  $mysqlPath = "$env:SystemDrive\Program Files\MySQL\MySQL Server 5.5\bin"
  if (![System.IO.Directory]::Exists($mysqlPath)) {$mysqlPath = "$env:SystemDrive\Program Files (x86)\MySQL\MySQL Server 5.5\bin";}
  Install-ChocolateyPath $mysqlPath 'Machine'

  #install the service itself
  Start-Process -FilePath "$mysqlPath\mysqld" -ArgumentList '--install' -Wait -NoNewWindow
  #turn on the service
  Start-Process -FilePath "NET" -ArgumentList 'START MySQL' -Wait -NoNewWindow
  
  Write-ChocolateySuccess "$packageName
} catch {
  Write-ChocolateyFailure "$packageName $($_.Exception.Message)
  throw 
}