@setlocal enableextensions enabledelayedexpansion

REM configure according to your preferences
set TARGET=clinicalgraphics
set PKG=gdcm
set VER=2.6.1
set CONDA_BLD_DIR=%userprofile%\Miniconda\conda-bld
set BUILD_NR=7
REM configure these lists for the pythons and architectures you want to support
set pythons=26_vc9 27_vc9 33_vc10 34_vc10 35_vc14
set architectures=64 32

REM try not to touch the rest of the code
for %%p in (%pythons%) do (
    set python=%%p
    conda build .\%PKG% --python !python:~0,2! --no-anaconda-upload
)

if not %architectures:32=%==%architectures% (
    REM conda32 should be a .bat script that prepends x86 conda.exe to the PATH
    call conda32
    for %%p in (%pythons%) do (
        set python=%%p
        conda build .\%PKG% --python !python:~0,2! --no-anaconda-upload
    )
)

for %%b in (%architectures%) do (
    for %%p in (%pythons%) do (
        anaconda upload "%CONDA_BLD_DIR%\win-%%b\%PKG%-%VER%-py%%p_%BUILD_NR%.tar.bz2" -u %TARGET%
    )
)
