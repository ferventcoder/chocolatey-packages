$id = "ruby.devkit"
$url = "https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe"

$tools = Split-Path $MyInvocation.MyCommand.Definition
$devkit = Join-Path (Get-BinRoot) "DevKit"

. (Join-Path $tools "rubydevkit.ps1")

Remove-RubyDevkit $devkit
