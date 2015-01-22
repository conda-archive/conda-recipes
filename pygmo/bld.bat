REM Rename needed boost libraries so that cmake can find them
pushd %LIBRARY_LIB%
for %%x in (system serialization thread python) do (
    copy /b libboost_%%x-*.dll.a boost_%%x.dll.a
    if errorlevel 1 exit 1
    copy /b libboost_%%x-*.dll boost_%%x.dll
    if errorlevel 1 exit 1
)
popd

REM Running cmake config step
mkdir build
cd build

set PATH=C:\msys\1.0\bin;%PREFIX%\MinGW\bin;%PATH%

cmake -G "MSYS Makefiles" -DCMAKE_MAKE_PROGRAM=make -DBUILD_PYGMO:BOOL=ON -DBUILD_MAIN:BOOL=OFF -DPYTHON_EXECUTABLE:FILEPATH=%PREFIX%\python.exe -DPYTHON_INCLUDE_PATH:PATH=%PREFIX%\include -DPYTHON_LIBRARY:FILEPATH=%PREFIX%\python27.dll -DBoost_INCLUDE_DIR:PATH=%LIBRARY_INC% -DBoost_LIBRARY_DIR:PATH=%LIBRARY_LIB% -DCMAKE_INSTALL_PREFIX=%PREFIX%\Lib\site-packages\ ..
if errorlevel 1 exit 1

REM Building
make
if errorlevel 1 exit 1

REM Installing
make install
if errorlevel 1 exit 1

REM Move dll's to PyGMO to make it self-contained
set PYGMO_DIR=%PREFIX%\Lib\site-packages\PyGMO

pushd %PREFIX%\Lib\site-packages\
for %%x in (algorithm core migration problem topology util) do (
    copy libpagmo.dll %PYGMO_DIR%\%%x
    if errorlevel 1 exit 1
)
del libpagmo.*
if errorlevel 1 exit 1
popd

pushd %LIBRARY_LIB%
for %%x in (chrono system serialization thread python) do (
    for %%y in (algorithm core migration problem topology util) do (
        copy /b libboost_%%x-*.* %PYGMO_DIR%\%%y
        if errorlevel 1 exit 1
    )
)
popd

pushd %PREFIX%\Scripts
for %%x in (libgcc_s_sjlj-1.dll libstdc++-6.dll) do (
    for %%y in (algorithm core migration problem topology util) do (
        copy "%%x" %PYGMO_DIR%\%%y
        if errorlevel 1 exit 1
    )
)
popd

REM Remove the renames did earlier for cmake so they don't be part of the package
pushd %LIBRARY_LIB%
for %%x in (system serialization thread python) do (
    del boost_%%x.*
    if errorlevel 1 exit 1
)
popd
