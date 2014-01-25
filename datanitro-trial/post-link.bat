
verify bogus-argument 2>nul
setlocal enableextensions enabledelayedexpansion
if ERRORLEVEL 1 (
    echo error: unable to enable command extensions
    goto end
)

set LICENSE_TXT=datanitro-trial-license.txt

set SETUP_EXE=datanitro-trial-setup.exe

rem Make sure we pick up the right path to python.exe based on where we've
rem been unpacked to.

set PYTHON_REL_EXE=..\..\python.exe

start /wait cmd /c %PYTHON_REL_EXE% ^
    -c "import sys; import os; open('datanitro-trial-python-exe.txt', 'w').write(sys.executable); open('datanitro-trial-conda-env-root.txt', 'w').write(os.path.basename(sys.executable))"

for /f "usebackq" %%p in (`type datanitro-trial-python-exe.txt`) do (
    set PYTHON_EXE=%%p
)

for /f "usebackq" %%p in (`type datanitro-trial-conda-env-root.txt`) do (
    set CONDA_ENV_ROOT=%%p
)

echo Found python: %PYTHON_EXE%
echo Root: %CONDA_ENV_ROOT%

:accept_license_agreement
    echo Accept license agreement?
    choice /c:yn
    if ERRORLEVEL 255 goto accept_license_agreement
    if ERRORLEVEL 2 exit /b 1
    if ERRORLEVEL 1 goto do_install
    goto accept_license_agreement

exit /b

:do_install
    echo Running DataNitro installer...

    start /wait cmd /c %SETUP_EXE% ^
        /e "anaconda-trial@datanitro.com" ^
        /y "%PYTHON_PATH%" ^
        /D=%CONDA_ENV_ROOT%\datanitro-trial

    if ERRORLEVEL 1 (
        echo Failed to install.
        goto end
    )

    exit /b

exit /b

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
