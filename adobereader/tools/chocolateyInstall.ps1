#http://forums.adobe.com/thread/754256
#http://www.appdeploy.com/messageboards/tm.asp?m=37416
# '/sPB /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES'
#'/sAll /rs /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"' 
#'/msi /norestart /quiet'
Install-ChocolateyPackage 'adobereader' 'exe' '/sPB /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES' 'http://ardownload.adobe.com/pub/adobe/reader/win/10.x/10.1.3/en_US/AdbeRdr1013_en_US.exe'
