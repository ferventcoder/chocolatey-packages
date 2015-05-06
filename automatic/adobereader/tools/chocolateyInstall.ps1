try {

$arguments = @{}

  # Now we can use the $env:chocolateyPackageParameters inside the Chocolatey package
  $packageParameters = $env:chocolateyPackageParameters

  # Default value
  $lcid = $null
  $RegValue = $null

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
  Import-Module (Join-Path $scriptDir 'common.ps1')
  #If no Language ID passed through, use the one from Windows
  #LCID table can be found at http://msdn.microsoft.com/es-es/goglobal/bb964664.aspx to manually pass through the desired language. 
   if (!$lcid){ 
    $lcid = (Get-Culture).LCID
    echo "LCID set to $lcid"  
   }


  $packageName = 'adobereader'
  $installerType = 'exe'
  $installArgs = "/sALL /rs /sl $lcid"
  
 #Kill the Adobe Updater AdobeARM.exe
  
  Stop-Process -processname AdobeARM -ErrorAction SilentlyContinue

  #Check for current version installed


    if ($currentinstall.DisplayVersion){
    $RegValue = $currentinstall.DisplayVersion 
    echo "Installed product detected. Version detected is $RegValue "
    
    }

  if ($RegValue -eq $version){
   echo "$version detected already installed. Skipping download and install."
  } else {
    Install-ChocolateyPackage $packageName $installerType $installArgs $url -validExitCodes @(0,3010)     
  }

} catch {
    throw $_.Exception
}