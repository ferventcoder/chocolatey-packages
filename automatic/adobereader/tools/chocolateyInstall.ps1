$packageName = 'adobereader'
$installerType = 'EXE'
#Command Line Switches for the Bootstrap Web Installer: https://forums.adobe.com/message/3291894#3291894
$silentArgs = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
$validExitCodes = @(0,3010) #3010: reboot required
#$url = 'http://ardownload.adobe.com/pub/adobe/reader/win/{mainversion}.x/{version}/en_US/AdbeRdr{version:replace:.:}_en_US.exe'
$url = '{{DownloadUrl}}'

Write-Debug "Detecting Locale..."
# LCID table: #http://msdn.microsoft.com/goglobal/bb964664.aspx
$mapping = @{
  1033="en_US"; # 1033 = English - United States
  2057="en_US"; # 2057 = English - United Kingdom
  3081="en_US"; # 3081 = English - Australia
  10249="en_US"; # 10249 = English - Belize
  4105="en_US"; # 4105 = English - Canada
  9225="en_US"; # 9225 = English - Caribbean
  15369="en_US"; # 15369 = English - Hong Kong SAR
  16393="en_US"; # 16393 = English - India
  14345="en_US"; # 14345 = English - Indonesia
  6153="en_US"; # 6153 = English - Ireland
  8201="en_US"; # 8201 = English - Jamaica
  17417="en_US"; # 17417 = English - Malaysia
  5129="en_US"; # 5129 = English - New Zealand
  13321="en_US"; # 13321 = English - Philippines
  18441="en_US"; # 18441 = English - Singapore
  7177="en_US"; # 7177 = English - South Africa
  11273="en_US"; # 11273 = English - Trinidad
  12297="en_US"; # 12297 = English - Zimbabwe
  1036="fr_FR"; # 1036 = French - France
  2060="fr_FR"; # 2060 = French - Belgium
  11276="fr_FR"; # 11276 = French - Cameroon
  3084="fr_FR"; # 3084 = French - Canada
  9228="fr_FR"; # 9228 = French - Democratic Rep. of Congo
  12300="fr_FR"; # 12300 = French - Cote d'Ivoire
  15372="fr_FR"; # 15372 = French - Haiti
  5132="fr_FR"; # 5132 = French - Luxembourg
  13324="fr_FR"; # 13324 = French - Mali
  6156="fr_FR"; # 6156 = French - Monaco
  14348="fr_FR"; # 14348 = French - Morocco
  58380="fr_FR"; # 58380 = French - North Africa
  8204="fr_FR"; # 8204 = French - Reunion
  10252="fr_FR"; # 10252 = French - Senegal
  4108="fr_FR"; # 4108 = French - Switzerland
  7180="fr_FR"; # 7180 = French - West Indies
  1122="fr_FR"; # 1122 = Frisian - Netherlands
  1127="fr_FR"; # 1127 = Fulfulde - Nigeria
  1071="fr_FR"; # 1071 = FYRO Macedonian
  1110="fr_FR"; # 1110 = Galician
  1079="fr_FR"; # 1079 = Georgian
  1031="de_DE"; # 1031 = German - Germany
  3079="de_DE"; # 3079 = German - Austria
  5127="de_DE"; # 5127 = German - Liechtenstein
  4103="de_DE"; # 4103 = German - Luxembourg
  2055="de_DE"; # 2055 = German - Switzerland
  1041="ja_JP"; # 1041 = Japanese
  3082="es_ES"; # 3082 = Spanish - Spain (Modern Sort)
  1034="es_ES"; # 1034 = Spanish - Spain (Traditional Sort)
  11274="es_ES"; # 11274 = Spanish - Argentina
  16394="es_ES"; # 16394 = Spanish - Bolivia
  13322="es_ES"; # 13322 = Spanish - Chile
  9226="es_ES"; # 9226 = Spanish - Colombia
  5130="es_ES"; # 5130 = Spanish - Costa Rica
  7178="es_ES"; # 7178 = Spanish - Dominican Republic
  12298="es_ES"; # 12298 = Spanish - Ecuador
  17418="es_ES"; # 17418 = Spanish - El Salvador
  4106="es_ES"; # 4106 = Spanish - Guatemala
  18442="es_ES"; # 18442 = Spanish - Honduras
  22538="es_ES"; # 22538 = Spanish - Latin America
  2058="es_ES"; # 2058 = Spanish - Mexico
  19466="es_ES"; # 19466 = Spanish - Nicaragua
  6154="es_ES"; # 6154 = Spanish - Panama
  15370="es_ES"; # 15370 = Spanish - Paraguay
  10250="es_ES"; # 10250 = Spanish - Peru
  20490="es_ES"; # 20490 = Spanish - Puerto Rico
  21514="es_ES"; # 21514 = Spanish - United States
  14346="es_ES"; # 14346 = Spanish - Uruguay
  8202="es_ES"; # 8202 = Spanish - Venezuela
}
$LCID = (Get-Culture).LCID
if ($mapping.ContainsKey($LCID)) {
  $locale = $mapping.Get_Item($LCID);
  Write-Host "Switching to $locale"
  $url = $url -replace 'en_US', "$locale"
} else { ## English
  Write-Debug "Leaving the url to the default English version."
  $url = $url
}

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
