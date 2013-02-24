#http://forums.adobe.com/thread/754256
#http://www.appdeploy.com/messageboards/tm.asp?m=37416
# '/sPB /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES'
#'/sAll /rs /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"' 
#'/msi /norestart /quiet'
Install-ChocolateyPackage 'adobereader' 'exe' '/sPB /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES' 'http://ardownload.adobe.com/pub/adobe/reader/win/11.x/11.0.01/en_US/AdobeRdr11001_en_US.exe'
#'http://www.filehippo.com/download/file/36a2fc371862e6889808cb3ef8fc7840357a0cfdedfd7c4c987cbf5805d872da'
