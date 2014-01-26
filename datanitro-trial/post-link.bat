@echo off

verify bogus-argument 2>nul
setlocal enableextensions enabledelayedexpansion
if ERRORLEVEL 1 (
    echo error: unable to enable command extensions
    goto :eof
)

echo.

set SCRIPTS=%~dp0

for /f %%i in ("%SCRIPTS%..") do (
    set CONDA_ROOT=%%~fi
)

set DN=%SCRIPTS%.datanitro-trial
set LICENSE_TXT=%DN%-license.txt
set SETUP_EXE=%DN%-setup.exe
set PYTHON_EXE=%CONDA_ROOT%\python.exe

:prompt_for_email
    set /p USER_EMAIL="Please enter your e-mail address to enable the trial: "
    if "%USER_EMAIL%" == "" (
        goto prompt_for_email
    )

type %LICENSE_TXT%

:accept_license_agreement
    echo Accept license agreement?
    choice /c:yn
    if ERRORLEVEL 255 goto accept_license_agreement
    if ERRORLEVEL 2 exit /b 1
    if ERRORLEVEL 1 goto do_install
    goto accept_license_agreement

exit /b

:do_install
    start /wait /min cmd /c %SETUP_EXE% /S ^
        /e "%USER_EMAIL%" ^
        /y "%CONDA_ROOT%" ^
        /D=%CONDA_ROOT%\datanitro-trial

    if ERRORLEVEL 1 (
        echo Failed to install.
        set ERROR=1
        goto :eof
    )

    exit /b

exit /b

:eof
if not defined ERROR (
    set ERROR=
)
if ERRORLEVEL 1 (
    set ERROR=1
)

del /q /s %LICENSE_TXT%
del /q /s %SETUP_EXE%

exit /b %ERROR%

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
