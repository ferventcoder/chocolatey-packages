try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'msysgit' 'exe' '/SILENT' 'http://msysgit.googlecode.com/files/Git-1.7.4-preview20110204.exe' 

#------- ADDITIONAL SETUP -------#
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  #get the PATH variable from the machine
  $envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit) {$progFiles = "$progFiles (x86)"}

  $gitPath = Join-Path $progFiles 'Git\cmd'
  #if you do not find C:\Program Files (x86)\Git\cmd, add it 
  if (!$envPath.ToLower().Contains($gitPath.ToLower()))
  {
    Write-Host ''
    #now we update the path
    Write-Host 'PATH environment variable does not have ' $gitPath ' in it. Adding.'

    #does the path end in ';'?
    $statementTerminator = ';'
    $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator) {$gitPath = $statementTerminator + $gitPath}
    $envPath = $envPath + $gitPath + $statementTerminator

    [Environment]::SetEnvironmentVariable( "Path", $envPath, [System.EnvironmentVariableTarget]::Machine )

@"

Adding git commands to the PATH
"@ | Write-Host


    #add it to the local path as well so users will be off and running
    $envPSPath = $env:PATH
    $env:Path = $envPSPath + $statementTerminator + $gitPath + $statementTerminator
  }

@"

Making GIT core.autocrlf false
"@ | Write-Host

  #make GIT core.autocrlf false
  & 'cmd.exe' '/c git config --global core.autocrlf false'

  Write-Host "Finished all setup of msysgit"
  Start-Sleep 4
} catch {
@"
Error Occurred: $($_.Exception.Message)
"@ | Write-Host -ForegroundColor White -BackgroundColor DarkRed
	Start-Sleep 5
	throw 
}