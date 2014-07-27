cinstm warmup

$templateDir = 'c:\code\_templates'
if (![System.IO.Directory]::Exists($templateDir)) {[System.IO.Directory]::CreateDirectory($templateDir)}

$chocoTemplateDir = Join-Path $templateDir 'chocolatey'
$currentDir = Get-Location
$targetDir = (Join-Path $currentDir (Join-Path '_template' 'chocolateyauto'))
  
write-host "We are setting up the _templates directory if it doesn't exist and then creating a symbolic link at `'$chocoTemplateDir`' pointing to `'$targetDir`'"
if (![System.IO.Directory]::Exists($chocoTemplateDir)) {
  write-host "Running mklink /d `"$chocoTemplateDir`" `"$targetDir`""
  & cmd /c "mklink /d `"$chocoTemplateDir`" `"$targetDir`""
}
