try {
  Get-ChildItem 'C:\NuGet\chocolateyInstall\helpers' -Filter *.psm1 | ForEach-Object { import-module -name  $_.FullName }
  Install-ChocolateyPackage 'kdiff3' 'exe' '/S' 'http://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.95/KDiff3Setup_0.9.95-2.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fkdiff3%2Ffiles%2Fkdiff3%2F0.9.95%2F&ts=1302319944&use_mirror=superb-sea2' 

  #------additional setup ----------------
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  #get the PATH variable from the machine
  $envPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit) {$progFiles = "$progFiles (x86)"}

  $programPath = Join-Path $progFiles 'kdiff3'
  #if you do not find C:\Program Files (x86)\kdiff3, add it 
  if (!$envPath.ToLower().Contains($programPath.ToLower()))
  {
    Write-Host ''
    #now we update the path
    Write-Host 'PATH environment variable does not have ' $programPath ' in it. Adding.'

    #does the path end in ';'?
    $statementTerminator = ';'
    $hasStatementTerminator= $envPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator) {$programPath = $statementTerminator + $programPath}
    $envPath = $envPath + $programPath + $statementTerminator

    [Environment]::SetEnvironmentVariable( "Path", $envPath, [System.EnvironmentVariableTarget]::Machine )

@"

Adding kdiff3 commands to the PATH
"@ | Write-Host

    #add it to the local path as well so users will be off and running
    $envPSPath = $env:PATH
    $env:Path = $envPSPath + $statementTerminator + $programPath + $statementTerminator
  }
  
  Write-Host "Finished all setup of kdiff3"
  Start-Sleep 4
} catch {
  Start-Sleep 10
}