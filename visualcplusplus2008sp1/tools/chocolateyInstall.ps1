try {
Install-ChocolateyPackage 'visualcplusplus2008sp1' 'EXE' '/quiet /norestart' 'http://www.microsoft.com/downloads/info.aspx?na=41&srcfamilyid=2051a0c1-c9b5-4b0a-a8f5-770a549fd78c&srcdisplaylang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f9%2f7%2f7%2f977B481A-7BA6-4E30-AC40-ED51EB2028F2%2fvcredist_x86.exe' 'http://www.microsoft.com/downloads/info.aspx?na=41&srcfamilyid=2051a0c1-c9b5-4b0a-a8f5-770a549fd78c&srcdisplaylang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f9%2f7%2f7%2f977B481A-7BA6-4E30-AC40-ED51EB2028F2%2fvcredist_x64.exe'  -validExitCodes @(0)
} catch {
  write-host "You may already have this installed: $($_.Exception.Message)"
}