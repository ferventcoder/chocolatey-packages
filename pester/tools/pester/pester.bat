@echo off
SET DIR=%~dp0%

call "%DIR%runtests.bat"

exit /B %errorlevel%