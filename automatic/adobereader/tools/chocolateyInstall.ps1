try {

$arguments = @{}

  # Now we can use the $env:chocolateyPackageParameters inside the Chocolatey package
  $packageParameters = $env:chocolateyPackageParameters

  # Default value
  $lcid = $null


  # Now parse the packageParameters using good old regular expression
  if ($packageParameters) {
      $match_pattern = "\/(?<option>([a-zA-Z0-9]+)):(?<value>([`"'])?([a-zA-Z0-9- \(\)\s_\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
      $option_name = 'option'
      $value_name = 'value'

      if ($packageParameters -match $match_pattern ){
          $results = $packageParameters | Select-String $match_pattern -AllMatches
          $results.matches | % {
            $arguments.Add(
                $_.Groups[$option_name].Value.Trim(),
                $_.Groups[$value_name].Value.Trim())
        }
      }
      else
      {
          Throw "Package Parameters were found but were invalid (REGEX Failure)"
      }

      if ($arguments.ContainsKey("lcid")) {
          Write-Host "lcid Argument Found"
          $lcid = $arguments["lcid"]
          echo "LCID set to $lcid"          
      } 


  } else {
      Write-Debug "No Package Parameters Passed in"
  }

  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  Import-Module (Join-Path $scriptDir 'checkinstall.ps1')
  #If no Language ID passed through, use the one from Windows
  #LCID table can be found at http://msdn.microsoft.com/es-es/goglobal/bb964664.aspx to manually pass through the desired language. 
   if (!$lcid){ 
    $lcid = (Get-Culture).LCID
    echo "LCID set to $lcid"  
   }

  
  # Find download URLs at http://www.adobe.com/support/downloads/product.jsp?platform=windows&product=10
  
  $url = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1500720033/AcroRdrDC1500720033_MUI.exe'
  $version = "15.007.20033"


  $packageName = 'adobereader'
  $installerType = 'exe'
  $installArgs = "/sALL /rs /sl $lcid"
  
 #Kill the Adobe Updater AdobeARM.exe
  
  Stop-Process -processname AdobeARM -ErrorAction SilentlyContinue

  #Check for current version installed

  #Check for OS bitness
if ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -match "64-bit"){
$SoftwareKey = "HKLM:\Software\WOW6432Node" 
} else {
$SoftwareKey = "HKLM:\Software" 
}
#This is the current Adobe Reader key. Would like to find a way to automate this part.
$RegKey = "$SoftwareKey\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-FFFF-7B44-AC0F074E4100}"
if (Test-Path "$RegKey") { 
echo "Key Detected. Checking version..."
     $RegValue = Get-ItemPropertyValue -Path $RegKey -Name DisplayVersion
    echo "Version $RegValue detected, installer is $version"
}




  if ($RegValue -eq $version){
   echo "$version detected already installed. Skipping download and install."
  } else {
    Install-ChocolateyPackage $packageName $installerType $installArgs $url -validExitCodes @(0,3010)     
  }

} catch {
  #Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}