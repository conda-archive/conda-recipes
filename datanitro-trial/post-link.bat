@echo off

verify bogus-argument 2>nul
setlocal enableextensions enabledelayedexpansion
if ERRORLEVEL 1 (
    echo error: unable to enable command extensions
    goto abort_installation
)

echo.

if defined ANA_DEBUG (
    echo Verifying .NET 4.x Framework is installed...
)

set DOTNET4X_REG=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\1033
set _CMD=reg query "%DOTNET4X_REG%" /v Install

for /f "usebackq skip=2 tokens=3,* delims= " %%i in (`%_CMD% 2^>NUL`) do (
    if "%%i"=="0x1" (
        set DOTNET4X_INSTALLED=1
    )
)
if defined DOTNET4X_INSTALLED goto dotnet4x_installed

echo Error: DataNitro requires a full .NET 4.x installation to be present.
echo Download: http://www.microsoft.com/en-us/download/details.aspx?id=30653
echo (Note: installation requires administrative privileges.^)
goto abort_installation

exit /b 1

:dotnet4x_installed
if defined ANA_DEBUG (
    echo Verifying Visual Studio 2010 Tools for Office Runtime is installed...
)

set VSTO_REG_WOW=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VSTO Runtime Setup\v4R
set VSTO_REG=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VSTO Runtime Setup\v4R

set _CMD=reg query "%VSTO_REG_WOW%" /v VSTORFeature_CLR40
for /f "usebackq skip=2 tokens=3,* delims= " %%i in (`%_CMD% 2^>NUL`) do (
    if "%%i"=="0x1" (
        set VSTO_INSTALLED=1
    )
)
if defined VSTO_INSTALLED goto vsto_installed

set _CMD=reg query "%VSTO_REG%" /v VSTORFeature_CLR40
for /f "usebackq skip=2 tokens=3,* delims= " %%i in (`%_CMD% 2^>NUL`) do (
    if "%%i"=="0x1" (
        set VSTO_INSTALLED=1
    )
)

if defined VSTO_INSTALLED goto vsto_installed

echo Error: Visual Studio 2010 Tools for Office Runtime has not been installed.
echo This a freely available download from Microsoft that must be present before
echo DataNitro can interact with Excel.
echo.
echo Download: http://www.microsoft.com/en-us/download/details.aspx?id=40790
echo (Note: installation requires administrative privileges.^)
goto abort_installation

:vsto_installed

set SCRIPTS=%~dp0

for /f %%i in ("%SCRIPTS%..") do (
    set CONDA_ROOT=%%~fi
)

set DN=%SCRIPTS%.datanitro-trial
set LICENSE_TXT=%DN%-license.txt
set SETUP_EXE=%DN%-setup.exe
set PYTHON_EXE=%CONDA_ROOT%\python.exe

rem Allow for automated/silent installs by setting DATANITRO_USER_EMAIL envvar.
if defined DATANITRO_USER_EMAIL goto show_license

:prompt_for_email
    set /p DATANITRO_USER_EMAIL="E-mail address to use for trial: "
    if not "%DATANITRO_USER_EMAIL%" == "" (
        (echo %DATANITRO_USER_EMAIL% | find /c "@" 1>NUL) && goto show_license
    )
    echo Invalid e-mail address.
    echo.
    echo Retry or quit?
    choice /c:rq
    if ERRORLEVEL 255 goto prompt_for_email
    if ERRORLEVEL 2 goto abort_installation
    goto prompt_for_email

:show_license
if "%DATANITRO_USER_EMAIL%" == "" (
    set DATANITRO_USER_EMAIL=conda-trial@datanitro.com
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
        /e "%DATANITRO_USER_EMAIL%" ^
        /y "%CONDA_ROOT%" ^
        /D=%CONDA_ROOT%\datanitro-trial

    if ERRORLEVEL 1 (
        echo Failed to install.
        set ERROR=1
        goto :eof
    )

    exit /b

exit /b
goto :eof

:abort_installation
    echo.
    echo Aborting installation.  Please type `conda remove datanitro-trial` to
    echo force a clean-up before attempting to re-install.
    set ERROR=1

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
