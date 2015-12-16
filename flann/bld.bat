mkdir build
cd build

cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% -DBUILD_C_BINDINGS:BOOL=ON -DBUILD_PYTHON_BINDINGS:BOOL=ON -DBUILD_MATLAB_BINDINGS:BOOL=OFF %SRC_DIR%
if errorlevel 1 exit 1

REM Build C libraries and tools
nmake
if errorlevel 1 exit 1

REM C Install step
nmake install
if errorlevel 1 exit 1

REM Python Install step
cd %LIBRARY_PREFIX%\share\flann\python
%PYTHON% setup.py install --prefix "%LIBRARY_PREFIX%"
if errorlevel 1 exit 1
