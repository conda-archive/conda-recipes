bash configure --prefix=$PREFIX --enable-shared
if errorlevel 1 exit 1
make
if errorlevel 1 exit 1
make install
if errorlevel 1 exit 1
