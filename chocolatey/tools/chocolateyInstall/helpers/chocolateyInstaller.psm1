function Install-ChocolateyPackage {
param([string] $packageName, [string] $fileType = 'exe',[string] $silentArgs = '',[string] $url,[string] $url64bit = $url,[switch] $silent)
	
	$chocTempDir = Join-Path $env:TEMP "chocolatey"
	$tempDir = Join-Path $chocTempDir "$packageName"
	if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
	$file = Join-Path $tempDir "$packageName.$fileType"
	
	$processor = Get-WmiObject Win32_Processor
	$is64bit = $processor.AddressWidth -eq 64
	$systemBit = '32 bit'
	if ($is64bit) {
		$systemBit = '64 bit';
		$url = $url64bit;
	}
	
	Write-Host "Downloading $packageName $systemBit ($url) to $file"

	#$downloader = new-object System.Net.WebClient
	#$downloader.DownloadFile($url, $file)
	Get-WebFile $url $file

	$installMessage = "Installing $packageName $systemBit"
	if ($silentArgs -ne '') { $installMessage = "$installMessage silently...";}
	write-host $installMessage
	
	if ($fileType -like 'msi') {
		$msiArgs = "/i `"$file`"" 
		if ($silentArgs -ne '') { $msiArgs = "$msiArgs /quiet";}
		Start-Process -FilePath msiexec -ArgumentList $msiArgs -Wait
	}
	if ($fileType -like 'exe') {
  	Start-Process -FilePath $file -ArgumentList $silentArgs -Wait 
		#"/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer
	}
	
	write-host "$packageName has been installed."
	Start-Sleep 5
}

Export-ModuleMember Install-ChocolateyPackage

# http://poshcode.org/417
## Get-WebFile (aka wget for PowerShell)
##############################################################################################################
## Downloads a file or page from the web
## History:
## v3.6 - Add -Passthru switch to output TEXT files
## v3.5 - Add -Quiet switch to turn off the progress reports ...
## v3.4 - Add progress report for files which don't report size
## v3.3 - Add progress report for files which report their size
## v3.2 - Use the pure Stream object because StreamWriter is based on TextWriter:
##        it was messing up binary files, and making mistakes with extended characters in text
## v3.1 - Unwrap the filename when it has quotes around it
## v3   - rewritten completely using HttpWebRequest + HttpWebResponse to figure out the file name, if possible
## v2   - adds a ton of parsing to make the output pretty
##        added measuring the scripts involved in the command, (uses Tokenizer)
##############################################################################################################
function Get-WebFile {
   param(
      $url = (Read-Host "The URL to download"),
      $fileName = $null,
      [switch]$Passthru,
      [switch]$quiet
   )
   
   $req = [System.Net.HttpWebRequest]::Create($url);
   $res = $req.GetResponse();
 
   if($fileName -and !(Split-Path $fileName)) {
      $fileName = Join-Path (Get-Location -PSProvider "FileSystem") $fileName
   }
   elseif((!$Passthru -and ($fileName -eq $null)) -or (($fileName -ne $null) -and (Test-Path -PathType "Container" $fileName)))
   {
      [string]$fileName = ([regex]'(?i)filename=(.*)$').Match( $res.Headers["Content-Disposition"] ).Groups[1].Value
      $fileName = $fileName.trim("\/""'")
      if(!$fileName) {
         $fileName = $res.ResponseUri.Segments[-1]
         $fileName = $fileName.trim("\/")
         if(!$fileName) {
            $fileName = Read-Host "Please provide a file name"
         }
         $fileName = $fileName.trim("\/")
         if(!([IO.FileInfo]$fileName).Extension) {
            $fileName = $fileName + "." + $res.ContentType.Split(";")[0].Split("/")[1]
         }
      }
      $fileName = Join-Path (Get-Location -PSProvider "FileSystem") $fileName
   }
   if($Passthru) {
      $encoding = [System.Text.Encoding]::GetEncoding( $res.CharacterSet )
      [string]$output = ""
   }
 
   if($res.StatusCode -eq 200) {
      [int]$goal = $res.ContentLength
      $reader = $res.GetResponseStream()
      if($fileName) {
         $writer = new-object System.IO.FileStream $fileName, "Create"
      }
      [byte[]]$buffer = new-object byte[] 4096
      [int]$total = [int]$count = 0
      do
      {
         $count = $reader.Read($buffer, 0, $buffer.Length);
         if($fileName) {
            $writer.Write($buffer, 0, $count);
         }
         if($Passthru){
            $output += $encoding.GetString($buffer,0,$count)
         } elseif(!$quiet) {
            $total += $count
            if($goal -gt 0) {
               Write-Progress "Downloading $url" "Saving $total of $goal" -id 0 -percentComplete (($total/$goal)*100) 
						} else {
               Write-Progress "Downloading $url" "Saving $total bytes..." -id 0 -Completed
            }
						if ($total -eq $goal) {
							Write-Progress "Completed download of $url." "Completed a total of $total bytes of $fileName" -id 0 -Completed 
						}
         }
      } while ($count -gt 0)
     
      $reader.Close()
      if($fileName) {
         $writer.Flush()
         $writer.Close()
      }
      if($Passthru){
         $output
      }
   }
   $res.Close();
}