@echo off
verify bogus-argument 2>nul
setlocal enableextensions enabledelayedexpansion
if errorlevel 1 (
    echo error: unable to enable command extensions
    exit /b 1
)

set SCRIPTS=%~dp0
for /f %%i in ("%SCRIPTS%..") do (
    set CONDA_ROOT=%%~fi
)

set VIM=%CONDA_ROOT%\vim
start /b %VIM%\vim74\gvim.exe
