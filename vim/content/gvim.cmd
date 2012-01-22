@echo off
setlocal ENABLEEXTENSIONS
IF DEFINED PROGRAMFILES(X86) SET VIMDIR=%PROGRAMFILES(X86)%\vim\vim73
IF NOT DEFINED PROGRAMFILES(X86) SET VIMDIR=%PROGRAMFILES%\vim\vim73
for %%A in ("%VIMDIR%") do set VIMDIR=%%~sA
IF "%1" NEQ "" (GOTO:OPENFILEINTAB) ELSE (GOTO:OPENEMPTYTAB)

:OPENFILEINTAB
START %VIMDIR%\gvim.exe --remote-tab-silent "%*"
GOTO:EOF

:OPENEMPTYTAB
FOR /F "tokens=*" %%i in ('%VIMDIR%\vim.exe --serverlist') do SET SERVERLIST=%%i
IF "%SERVERLIST%" NEQ "" (%VIMDIR%\gvim.exe --remote-send "<C-\><C-N>:tabnew<CR>") ELSE (start %VIMDIR%\gvim.exe)
