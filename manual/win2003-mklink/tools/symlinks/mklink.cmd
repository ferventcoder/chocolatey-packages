@echo off

SET DIR=%~dp0%
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%DIR%Symlink.ps1' %*"

pushd "%DIR%"
%DIR%senable.exe start
popd