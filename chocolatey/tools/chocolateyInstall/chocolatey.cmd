@echo off


if '%1' == '/?' goto usage
if '%1' == '-?' goto usage
if '%1' == '?' goto usage
if '%1' == '/help' goto usage
if '%1' == 'help' goto usage

SET DIR=%~d0%~p0%
%windir%\System32\WindowsPowerShell\v1.0\powershell.exe "%DIR%chocolatey.ps1 %*"

goto finish

:usage

%windir%\System32\WindowsPowerShell\v1.0\powershell.exe "%DIR%chocolatey.ps1 help"

:finish