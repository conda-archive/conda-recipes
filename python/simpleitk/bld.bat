mkdir C:\b
cd C:\b

REM Remove dot from PY_VER for use in library name
set MY_PY_VER=%PY_VER:.=%

REM Configure Step
cmake -G "%CMAKE_GENERATOR%" ^
    -D SimpleITK_BUILD_DISTRIBUTE:BOOL=ON ^
    -D BUILD_SHARED_LIBS:BOOL=OFF ^
    -D BUILD_TESTING:BOOL=OFF ^
    -D BUILD_EXAMPLES:BOOL=OFF ^
    -D WRAP_CSHARP:BOOL=OFF ^
    -D WRAP_LUA:BOOL=OFF ^
    -D WRAP_PYTHON:BOOL=ON ^
    -D WRAP_JAVA:BOOL=OFF ^
    -D WRAP_CSHARP:BOOL=OFF ^
    -D WRAP_TCL:BOOL=OFF ^
    -D WRAP_R:BOOL=OFF ^
    -D WRAP_RUBY:BOOL=OFF ^
    -D USE_SYSTEM_SWIG:BOOL=ON ^
    -D ITK_USE_SYSTEM_JPEG:BOOL=ON ^
    -D ITK_USE_SYSTEM_PNG:BOOL=ON ^
    -D ITK_USE_SYSTEM_TIFF:BOOL=ON ^
    -D ITK_USE_SYSTEM_ZLIB:BOOL=ON ^
    -D "CMAKE_SYSTEM_PREFIX_PATH:PATH=%PREFIX%/Library" ^
    -D "PYTHON_EXECUTABLE:FILEPATH=%PYTHON%" ^
    -D "PYTHON_INCLUDE_DIR:PATH=%PREFIX%/include" ^
    -D "PYTHON_LIBRARY:FILEPATH=%PREFIX%/libs/python%MY_PY_VER%.lib" ^
    "%SRC_DIR%/SuperBuild"

if errorlevel 1 exit 1
    
REM Build step
cmake --build  . --config Release
if errorlevel 1 exit 1

REM Install step
REM cmake --build  . --config Release --target INSTALL
if errorlevel 1 exit 1

cd SimpleITK-build\Wrapping\Python
%PYTHON% Packaging\setup.py install
