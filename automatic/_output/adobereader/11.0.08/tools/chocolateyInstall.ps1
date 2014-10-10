$silentArgs = '/sPB /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
$downloadUrl = 'http://ardownload.adobe.com/pub/adobe/reader/win/11.x/11.0.08/en_US/AdbeRdr11008_en_US.exe'
#http://forums.adobe.com/thread/754256
#http://www.appdeploy.com/messageboards/tm.asp?m=37416
# '/sPB /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES'
#'/sAll /rs /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"' 
#'/msi /norestart /quiet'
Install-ChocolateyPackage 'adobereader' 'exe' "$silentArgs" "$downloadUrl"