$silentArgs = '/sPB /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
$downloadUrl = '{{DownloadUrl}}'
#http://forums.adobe.com/thread/754256
#http://www.appdeploy.com/messageboards/tm.asp?m=37416
# '/sPB /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES'
#'/sAll /rs /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"' 
#'/msi /norestart /quiet'
Install-ChocolateyPackage 'adobereader' 'exe' "$silentArgs" "$downloadUrl"