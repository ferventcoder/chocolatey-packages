try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  
  #http://forums.adobe.com/thread/754256
  #http://www.appdeploy.com/messageboards/tm.asp?m=37416
  # '/sPB /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES'
  #'/sAll /rs /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"' 
  #'/msi /norestart /quiet'
  Install-ChocolateyPackage 'adobereader' 'exe' '/msi /norestart /quiet' 'http://ardownload.adobe.com/pub/adobe/reader/win/10.x/10.0.1/en_US/AdbeRdr1001_en_US.exe'
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 8
	throw 
}