@rem See https://github.com/jyypma/nloptr/blob/master/INSTALL.windows
cp "%RECIPE_DIR%\CMakeLists.txt" .
if errorlevel 1 exit 1
cp "%RECIPE_DIR%\config.cmake.h.in" .
if errorlevel 1 exit 1
cmake -DCMAKE_INSTALL_PREFIX="%PREFIX%" -DCMAKE_BUILD_TYPE=Release .
if errorlevel 1 exit 1
