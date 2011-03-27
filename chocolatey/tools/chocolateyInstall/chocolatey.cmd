@echo off

SET DIR=%~d0%~p0%
SET CHOCDIR=C:\NuGet\chocolateyInstall\

if '%1'=='/?' goto usage
if '%1'=='-?' goto usage
if '%1'=='?' goto usage
if '%1'=='/help' goto usage
if '%1'=='help' goto usage

%windir%\System32\WindowsPowerShell\v1.0\powershell.exe "%CHOCDIR%chocolatey.ps1 %*"

goto finish

:usage

%windir%\System32\WindowsPowerShell\v1.0\powershell.exe "%CHOCDIR%chocolatey.ps1"

:finish