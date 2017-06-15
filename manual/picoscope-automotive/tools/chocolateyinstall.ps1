# https://www.picotech.com/support/topic4836.html
$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# add the cert if it is not installed
$cert = ls cert: -Recurse | ? { $_.Thumbprint -eq 'c81acdafc8b82ef2aef5ce0ff2a7f28eea1456f7' }
if (!$cert) {
    $toolsPath = Split-Path $MyInvocation.MyCommand.Definition
    Start-ChocolateyProcessAsAdmin "certutil -addstore 'TrustedPublisher' '$toolsPath\pico.cer'"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'PicoScope 6 Automotive*'
  fileType      = 'exe'
  silentArgs    = "/s /v`"/qn REBOOT=ReallySuppress DEFAULT_CONVERTER=100 INSTALL_ALL_CONVERTERS=`"Yes`" /lv* `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`"`" /sms"
  validExitCodes= @(0,1641,3010)
  url           = "https://www.picoauto.com/download/software/sr/PicoScope6Automotive_r6_12_7.exe"
  checksum      = '4C30E693B9B88279C00B3C933EF33DDA3449CFA68E35FB57F58993DB0BC8545C'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
