  
  # Find download URLs at http://www.adobe.com/support/downloads/product.jsp?platform=windows&product=10
  
  $url = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1500720033/AcroRdrDC1500720033_MUI.exe'
  $version = "15.007.20033"

  try {
  $packageGuid = Get-ChildItem HKLM:\SOFTWARE\Classes\Installer\Products -ErrorAction SilentlyContinue |
    	Get-ItemProperty -Name 'ProductName' -ErrorAction SilentlyContinue |
    	? { $_.ProductName -like "Adobe" + "*" + "Reader" + "*"} |
    	Select -ExpandProperty PSChildName -First 1 -ErrorAction SilentlyContinue
	    write-host "Detected GUID: $packageGuid" 
        $currentinstall = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$packageGuid\InstallProperties -ErrorAction SilentlyContinue
  } catch {
  echo "Could not detect GUID"
  }