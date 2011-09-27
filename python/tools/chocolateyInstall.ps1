try { 
  Install-ChocolateyPackage 'python' 'msi' '/quiet' 'http://www.python.org/ftp/python/2.7.2/python-2.7.2.msi' 'http://www.python.org/ftp/python/2.7.2/python-2.7.2.amd64.msi' 

  Install-ChocolateyPath 'C:\Python27' 'User'
  
  Write-ChocolateySuccess 'python'
} catch {
  Write-ChocolateyFailure 'python' "$($_.Exception.Message)"
  throw 
}