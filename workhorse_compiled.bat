setlocal EnableDelayedExpansion

set TARGET=clinicalgraphics
set PKG=gdcm
set VER=2.6.1
set CONDA_BLD_DIR=%userprofile%\Miniconda\conda-bld
set BUILD_NR=7

set pythons=26_vc9 27_vc9 33_vc10 34_vc10 35_vc14

for %%p in (%pythons%) do (
    set python=%%p
    conda build .\%PKG% --python !python:~0,2! --no-anaconda-upload
)

call conda32

for %%p in (%pythons%) do (
    set python=%%p
    conda build .\%PKG% --python !python:~0,2! --no-anaconda-upload
)

for %%b in (64 32) do (
    for %%p in (%pythons%) do (
        anaconda upload "%CONDA_BLD_DIR%\win-%%b\%PKG%-%VER%-py%%p_%BUILD_NR%.tar.bz2" -u %TARGET%
    )
)
