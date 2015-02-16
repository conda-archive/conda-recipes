REM Start with boost.build bootstrap
echo This requires to have Visual Studio C++ compiler installed because
echo Boost build system (bjam) can't be compiled with MinGW at
echo the moment
call bootstrap.bat
if errorlevel 1 exit 1

REM Compiling boost with MinGW
set PATH=%PREFIX%\MinGW\bin;%PATH%
if "%ARCH%"=="32" (set BOOST_TOOLSET=gcc) else (set BOOST_TOOLSET=gcc address-model=64 cxxflags="-D MS_WIN64 ")

REM Build step
bjam --build-dir=buildboost toolset=%BOOST_TOOLSET% variant=release threading=multi link=shared --prefix=%LIBRARY_PREFIX% install

REM Install fix-up for a non version-specific boost include
move %LIBRARY_INC%\boost-1_57\boost %LIBRARY_INC%