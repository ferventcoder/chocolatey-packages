$tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

function Is64Bit {  [IntPtr]::Size -eq 8  }

if(Is64Bit) {$fx="framework64"} else {$fx="framework"}
if(!(test-path "$env:windir\Microsoft.Net\$fx\v2.0.50727")) {
  $packageArgs = "/c DISM /Online /NoRestart /Enable-Feature /FeatureName:NetFx3"
  $statements = "cmd.exe $packageArgs"
  Start-ChocolateyProcessAsAdmin "$statements" -minimized -nosleep -validExitCodes @(0,1)
}

Install-ChocolateyPackage 'fiddler' 'exe' '/S' 'http://www.getfiddler.com/dl/Fiddler2Setup.exe'