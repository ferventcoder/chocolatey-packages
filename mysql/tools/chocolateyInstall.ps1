try {
  Install-ChocolateyPackage 'mysql' 'msi' '/passive' 'http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.14-win32.msi/from/http://mysql.he.net/' 'http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.14-winx64.msi/from/http://mysql.mirrors.hoobly.com/' 
  
  #------- ADDITIONAL SETUP -------#
  #add it to the path
  $sysDrive = $env:SystemDrive
  $mysqlPath = "$sysDrive\Program Files\MySQL\MySQL Server 5.5\bin"
  if (![System.IO.Directory]::Exists($mysqlPath)) {$mysqlPath = "$sysDrive\Program Files (x86)\MySQL\MySQL Server 5.5\bin";}
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