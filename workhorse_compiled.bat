set TARGET=clinicalgraphics
set PKG=gdcm
set VER=2.6.1
set CONDA_BLD_DIR=%userprofile%\Miniconda\conda-bld
set BUILD_NR=7

for %%p in (26 27 33 34 35) do (
    conda build .\%PKG% --python %%p --no-anaconda-upload
)

call conda32

for %%p in (26 27 33 34 35) do (
    conda build .\%PKG% --python %%p --no-anaconda-upload
)

anaconda upload "%CONDA_BLD_DIR%\win-64\%PKG%-%VER%-py26_vc9_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-64\%PKG%-%VER%-py27_vc9_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-64\%PKG%-%VER%-py33_vc10_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-64\%PKG%-%VER%-py34_vc10_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-64\%PKG%-%VER%-py35_vc14_%BUILD_NR%.tar.bz2" -u %TARGET%

anaconda upload "%CONDA_BLD_DIR%\win-32\%PKG%-%VER%-py26_vc9_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-32\%PKG%-%VER%-py27_vc9_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-32\%PKG%-%VER%-py33_vc10_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-32\%PKG%-%VER%-py34_vc10_%BUILD_NR%.tar.bz2" -u %TARGET%
anaconda upload "%CONDA_BLD_DIR%\win-32\%PKG%-%VER%-py35_vc14_%BUILD_NR%.tar.bz2" -u %TARGET%
