@echo off
set SCRIPTS=%~dp0

for /f %%i in ("%SCRIPTS%..") do (
    set CONDA_ROOT=%%~fi
)

set DN=%CONDA_ROOT%\datanitro-trial
set UNINSTALL_EXE=%DN%\uninstaller.exe

start /wait /min cmd /c %UNINSTALL_EXE% /S

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
