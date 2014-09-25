$packageName = 'adobereader'
$installerType = 'EXE'
$silentArgs = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
#$url = 'http://ardownload.adobe.com/pub/adobe/reader/win/{mainversion}.x/{version}/en_US/AdbeRdr{version:replace:.:}_en_US.exe'
$url = 'http://ardownload.adobe.com/pub/adobe/reader/win/11.x/11.0.09/en_US/AdbeRdr11009_en_US.exe'
#http://forums.adobe.com/thread/754256
#http://www.appdeploy.com/messageboards/tm.asp?m=37416
# '/sPB /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES'
#'/sAll /rs /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"'
#'/msi /norestart /quiet'

# the url changes based on the language - not entirely happy with the way this works
$LCID = (Get-Culture).LCID
if(($LCID -eq "3082") -or ($LCID -eq "1034")){ ## Spanish
  $url = $url -replace 'en_US', 'es_ES'
} elseif($LCID -eq "1036"){ ## French
  $url = $url -replace 'en_US', 'fr_FR'
} elseif($LCID -eq "1031"){ ## German
  $url = $url -replace 'en_US', 'de_DE'
} elseif($LCID -eq "1041"){ ## Japanese
  $url = $url -replace 'en_US', 'ja_JP'
} else{ ## English
  $url = $url
}

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"

#LCID table
#http://msdn.microsoft.com/es-es/goglobal/bb964664.aspx
