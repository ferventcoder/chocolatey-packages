@echo off
setlocal ENABLEEXTENSIONS
IF "%1" NEQ "" (GOTO:OPENFILEINTAB) ELSE (GOTO:OPENEMPTYTAB)

:OPENFILEINTAB
START VIM_DIRECTORY\gvim.exe --remote-tab-silent "%*"
GOTO:EOF

:OPENEMPTYTAB
FOR /F "tokens=*" %%i in ('VIM_DIRECTORY\vim.exe --serverlist') do SET SERVERLIST=%%i
IF "%SERVERLIST%" EQU "" (start VIM_DIRECTORY\gvim.exe) ELSE (VIM_DIRECTORY\gvim.exe --remote-send "<C-\><C-N>:tabnew<CR>")
