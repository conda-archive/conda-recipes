
mkdir build
if errorlevel 1 exit 1

cd build
if errorlevel 1 exit 1

cmake -DCMAKE_INSTALL_PREFIX=%PREFIX% -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -DLAPACKE=ON -DCMake_GNUtoMS=ON ..
if errorlevel 1 exit 1

make -j2
if errorlevel 1 exit 1

make install
if errorlevel 1 exit 1
