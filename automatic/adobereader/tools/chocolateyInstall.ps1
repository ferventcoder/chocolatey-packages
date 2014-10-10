$packageName = 'adobereader'
$installerType = 'EXE'
$silentArgs = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
#$url = 'http://ardownload.adobe.com/pub/adobe/reader/win/{mainversion}.x/{version}/en_US/AdbeRdr{version:replace:.:}_en_US.exe'
$url = '{{DownloadUrl}}'
#http://forums.adobe.com/thread/754256
#http://www.appdeploy.com/messageboards/tm.asp?m=37416
# '/sPB /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES'
#'/sAll /rs /msi "/qb-! /norestart ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"'
#'/msi /norestart /quiet'

# the url changes based on the language - not entirely happy with the way this works
Write-Debug "Detecting Locale..."
$LCID = (Get-Culture).LCID
if(($LCID -eq "3082") -or ($LCID -eq "1034")){ ## Spanish
  Write-Host "Switching to Spanish version"
  $url = $url -replace 'en_US', 'es_ES'
} elseif($LCID -eq "1036"){ ## French
  Write-Host "Switching to French version"
  $url = $url -replace 'en_US', 'fr_FR'
} elseif($LCID -eq "2060"){ ## French Belgium
  Write-Host "Switching to French version"
  $url = $url -replace 'en_US', 'fr_FR'
} elseif($LCID -eq "1031"){ ## German
  Write-Host "Switching to German version"
  $url = $url -replace 'en_US', 'de_DE'
} elseif($LCID -eq "1041"){ ## Japanese
  Write-Host "Switching to Japanese version"
  $url = $url -replace 'en_US', 'ja_JP'
} else { ## English
  Write-Debug "Leaving the url to the default English version."
  $url = $url
}

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"

#LCID table
#http://msdn.microsoft.com/es-es/goglobal/bb964664.aspx
