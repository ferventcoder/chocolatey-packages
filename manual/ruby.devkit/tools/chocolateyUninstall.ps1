$tools = Split-Path $MyInvocation.MyCommand.Definition
$devkit = Join-Path (Get-BinRoot) "DevKit"

. (Join-Path $tools "rubydevkit.ps1")

Remove-RubyDevkit $devkit
