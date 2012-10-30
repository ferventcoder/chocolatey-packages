function Install-ChocolateyPackage-Spotify {
param(
  [string] $packageName, 
  [string] $fileType = 'exe',
  [string] $silentArgs = '',
  [string] $url,
  [string] $url64bit = $url,
  $validExitCodes = @(0)
)
  
  try {
    Write-Debug "Running 'Install-ChocolateyPackage' for $packageName with url:`'$url`', args: `'$silentArgs`' ";

    $chocTempDir = Join-Path $env:TEMP "chocolatey"
    $tempDir = Join-Path $chocTempDir "$packageName"
    if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir) | Out-Null}
    $file = Join-Path $tempDir "$($packageName)Install.$fileType"
  
    Get-ChocolateyWebFile $packageName $file $url $url64bit
    Install-ChocolateyInstallPackage-Spotify $packageName $fileType $silentArgs $file -validExitCodes $validExitCodes
    Write-ChocolateySuccess $packageName
  } catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw 
  }
}

function Install-ChocolateyInstallPackage-Spotify {
param(
  [string] $packageName, 
  [string] $fileType = 'exe',
  [string] $silentArgs = '',
  [string] $file,
  $validExitCodes = @(0)
)
  Write-Debug "Running 'Install-ChocolateyInstallPackage' for $packageName with file:`'$file`', args: `'$silentArgs`' ";
  $installMessage = "Installing $packageName..."
  write-host $installMessage

  $additionalInstallArgs = $env:chocolateyInstallArguments;
  if ($additionalInstallArgs -eq $null) { $additionalInstallArgs = ''; }
  $overrideArguments = $env:chocolateyInstallOverride;
    
  if ($fileType -like 'msi') {
    $msiArgs = "/i `"$file`"" 
    if ($overrideArguments) { 
      $msiArgs = "$msiArgs $additionalInstallArgs";
      write-host "Overriding package arguments with `'$additionalInstallArgs`'";
    } else {
      $msiArgs = "$msiArgs $silentArgs $additionalInstallArgs";
    }
    
    Start-ChocolateyProcessAsAdmin-Spotify "$msiArgs" 'msiexec' -validExitCodes $validExitCodes
    #Start-Process -FilePath msiexec -ArgumentList $msiArgs -Wait
  }
  if ($fileType -like 'exe') {
    if ($overrideArguments) {
      Start-ChocolateyProcessAsAdmin-Spotify "$additionalInstallArgs" $file -validExitCodes $validExitCodes
      write-host "Overriding package arguments with `'$additionalInstallArgs`'";
    } else {
      Start-ChocolateyProcessAsAdmin-Spotify "$silentArgs $additionalInstallArgs" $file -validExitCodes $validExitCodes
    }
  }

  write-host "$packageName has been installed."
}


function Start-ChocolateyProcessAsAdmin-Spotify {
param(
  [string] $statements, 
  [string] $exeToRun = 'powershell',
  [switch] $minimized,
  [switch] $noSleep,
  $validExitCodes = @(0)
)
  Write-Host 'Overriding chocolatey function to run Start-ChocolateyProcessAsAdmin without RunAs'
  Write-Debug "Running 'Start-ChocolateyProcessAsAdmin-Override' with exeToRun:`'$exeToRun`', statements: `'$statements`' ";
  
  $wrappedStatements = $statements;
  if ($exeToRun -eq 'powershell') {
    $exeToRun = "$($env:windir)\System32\WindowsPowerShell\v1.0\powershell.exe"
    if (!$statements.EndsWith(';')){$statements = $statements + ';'}
    $importChocolateyHelpers = "";
    Get-ChildItem "$helpersPath" -Filter *.psm1 | ForEach-Object { $importChocolateyHelpers = "& import-module -name  `'$($_.FullName)`';$importChocolateyHelpers" };
    $wrappedStatements = "-NoProfile -ExecutionPolicy unrestricted -Command `"$importChocolateyHelpers try{$statements start-sleep 6;}catch{write-error `'That was not sucessful`';start-sleep 8;throw;}`""
    if ($noSleep) {
      $wrappedStatements = "-NoProfile -ExecutionPolicy unrestricted -Command `"$importChocolateyHelpers try{$statements}catch{write-error `'That was not sucessful`';throw;}`""
    }
  }
@"
Running $exeToRun $wrappedStatements. This may take awhile, depending on the statements.
"@ | Write-Host

  $psi = new-object System.Diagnostics.ProcessStartInfo;
  $psi.FileName = $exeToRun;
  if ($wrappedStatements -ne '') {
    $psi.Arguments = "$wrappedStatements";
  }
  #$psi.Verb = "runas";
  $psi.WorkingDirectory = get-location;

  if ($minimized) {
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized;
  }
 
  $s = [System.Diagnostics.Process]::Start($psi);
  $s.WaitForExit();
  if ($validExitCodes -notcontains $s.ExitCode) {
    $errorMessage = "[ERROR] Running $exeToRun with $statements was not successful. Exit code was `'$($s.ExitCode)`'."
    Write-Error $errorMessage
    throw $errorMessage
  }

  Write-Debug "Finishing 'Start-ChocolateyProcessAsAdmin-Override'";
}

Export-ModuleMember -Function Install-ChocolateyPackage-Spotify,Install-ChocolateyInstallPackage-Spotify, Start-ChocolateyProcessAsAdmin-Spotify
