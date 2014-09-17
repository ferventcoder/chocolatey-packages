$packageName = 'iscommandlineapp'
$url = 'http://files.helgeklein.com/downloads/IsCommandLineApp/current/IsCommandLineApp.zip'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

