try { 
  #http://www.enterprisedb.com/products-services-training/pgdownload#windows
  #http://www.enterprisedb.com/resources-community/pginst-guide
  
  
  
  #create postgres user with password Postgres1234
  #Could do this - http://blogs.technet.com/b/heyscriptingguy/archive/2010/11/23/use-powershell-to-create-local-user-accounts.aspx | http://www.yusufozturk.info/windows-server/how-to-create-windows-user-with-powershell-2.html | http://stackoverflow.com/questions/383390/create-local-user-with-powershell-windows-vista
  $postgreAccount = 'postgres'
  Write-Host "Deleting and recreating $postgreAccount windows account..."
  try {
    net user $postgreAccount /delete
  } catch {
    Write-Host "User $postgreAccount doesn`'t exist"
  }
  net user $postgreAccount Postgres1234 /add
  #create sysdrive\PostgreSQL folder
  $postgrePath = "$($env:SystemDrive)\PostgreSQL"
  Write-Host "Creating $postgrePath folder for installation if it doesn`'t exist"
  if (![System.IO.Directory]::Exists($postgrePath)) {[System.IO.Directory]::CreateDirectory($postgrePath)}
  #assign folder permissions to postgres user
  Write-Host "Setting folder permissions on $postgrePath to full control for user postgres"
  $acl = Get-Acl $postgrePath
  $acl.SetAccessRuleProtection($True, $True)
  $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$postgreAccount","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow");
  $acl.AddAccessRule($rule);
  Set-Acl $postgrePath $acl
  
  Install-ChocolateyPackage 'postgresql' 'exe' "--mode unattended --prefix $postgrePath --superpassword Postgres1234" 'http://get.enterprisedb.com/postgresql/postgresql-9.1.1-1-windows.exe' 
#'http://get.enterprisedb.com/postgresql/postgresql-9.1.1-1-windows-x64.exe' 

  Write-Host "Please change the password for the PostgreSQL account and update the services to that password"

  
  Write-ChocolateySuccess 'postgresql'
} catch {
  Write-ChocolateyFailure 'postgresql' "$($_.Exception.Message)"
  throw 
}