try {
  Install-ChocolateyPackage 'mysql' 'msi' '/passive' 'http://www.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.18-win32.msi/from/http://mysql.he.net/' 'http://www.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.18-winx64.msi/from/http://mysql.he.net/' 
  
  #------- ADDITIONAL SETUP -------#
  #add it to the path
  $mysqlPath = "$env:SystemDrive\Program Files\MySQL\MySQL Server 5.5\bin"
  if (![System.IO.Directory]::Exists($mysqlPath)) {$mysqlPath = "$env:SystemDrive\Program Files (x86)\MySQL\MySQL Server 5.5\bin";}
  Install-ChocolateyPath $mysqlPath 'Machine'

  #install the service itself
  Start-Process -FilePath "$mysqlPath\mysqld" -ArgumentList '--install' -Wait -NoNewWindow
  #turn on the service
  Start-Process -FilePath "NET" -ArgumentList 'START MySQL' -Wait -NoNewWindow
  
  Write-ChocolateySuccess 'mysql'
} catch {
  Write-ChocolateyFailure 'mysql' $($_.Exception.Message)
  throw 
}