#!/bin/sh

# tested on OSX 10.8.5

ncpus=1
if test -x /usr/bin/getconf; then
    ncpus=$(/usr/bin/getconf _NPROCESSORS_ONLN)
fi

cd orocos_kdl
echo "in directory: " `pwd`

cmake -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DEIGEN3_INCLUDE_DIR=$PREFIX/include/eigen3 \

make -j$ncpus
make install

cd ..
cd python_orocos_kdl 

cmake   -DPYTHON_PACKAGES_DIR_NAME="site-packages" \
        -DPYTHON_SITE_PACKAGES_INSTALL_DIR=$PREFIX/lib/python2.7/site-packages \
        -Dorocos_kdl_DIR=$PREFIX/share/orocos_kdl \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DPYTHON_INCLUDE_DIR=$PREFIX/include/python2.7 \
        -DPYTHON_LIBRARY=$PREFIX/lib/libpython2.7.dylib \

make -j$ncpus
make install

if [ `uname` == Darwin ]; then
    # python doesnt swallow .dylib for extensions
    mv $PREFIX/lib/python2.7/site-packages/PyKDL.dylib $PREFIX/lib/python2.7/site-packages/PyKDL.so
fi

