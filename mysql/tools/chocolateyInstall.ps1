try {
  Install-ChocolateyPackage 'mysql' 'msi' '/passive' 'http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.13-win32.msi/from/http://mysql.he.net/' 'http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.13-winx64.msi/from/http://mysql.mirrors.hoobly.com/' 
  
  #------- ADDITIONAL SETUP -------#
  #add it to the path
  $sysDrive = $env:SystemDrive
  $mysqlPath = "$sysDrive\Program Files\MySQL\MySQL Server 5.5\bin"
  if (![System.IO.Directory]::Exists($mysqlPath)) {$mysqlPath = "$sysDrive\Program Files (x86)\MySQL\MySQL Server 5.5\bin";}
  $envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
  if (!$envPath.ToLower().Contains($mysqlPath.ToLower()))
  {
    Write-Host "PATH environment variable does not have $mysqlPath in it. Adding..."

    $statementTerminator = ";"
    #does the path end in ';'?
    $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator) {$mysqlPath = $statementTerminator + $mysqlPath}
    $envPath = $envPath + $mysqlPath + $statementTerminator

    [Environment]::SetEnvironmentVariable('Path', $envPath, [System.EnvironmentVariableTarget]::Machine)
  }

  #install the service itself
  Start-Process -FilePath "$mysqlPath\mysqld" -ArgumentList '--install' -Wait -NoNewWindow
  #turn on the service
  Start-Process -FilePath "NET" -ArgumentList 'START MySQL' -Wait -NoNewWindow
  
  Write-ChocolateySuccess 'mysql'
} catch {
  Write-ChocolateyFailure 'mysql' $($_.Exception.Message)
  throw 
}