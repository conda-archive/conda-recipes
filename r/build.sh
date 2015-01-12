#!/bin/bash

# Without setting these, R goes off and tries to find things on its own, which
# we don't want (we only want it to find stuff in the build environment).

export CFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include"
export FFLAGS="-I$PREFIX/include -L$PREFIX/lib"
export FCFLAGS="-I$PREFIX/include -L$PREFIX/lib"
export OBJCFLAGS="-I$PREFIX/include"
export CXXFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib -lgfortran"
export LAPACK_LDFLAGS="-L$PREFIX/lib -lgfortran"
export PKG_CPPFLAGS="-I$PREFIX/include"
export PKG_LDFLAGS="-L$PREFIX/lib -lgfortran"
export TCL_CONFIG=$PREFIX/lib/tclConfig.sh
export TK_CONFIG=$PREFIX/lib/tkConfig.sh
export TCL_LIBRARY=$PREFIX/lib/tcl8.5
export TK_LIBRARY=$PREFIX/lib/tk8.5

if [[ (`uname` == Linux) ]]; then

    # There's probably a much better way to do this.
    . ${RECIPE_DIR}/java.rc
    if [ -n "$JDK_HOME" -a -n "$JAVA_HOME" ]; then
        export JAVA_CPPFLAGS="-I$JDK_HOME/include -I$JDK_HOME/include/linux"
        export JAVA_LD_LIBRARY_PATH=${JAVA_HOME}/lib/amd64/server
    else
        echo warning: JDK_HOME and JAVA_HOME not set
    fi

    mkdir -p $PREFIX/lib

    ./configure --with-x                        \
                --with-pic                      \
                --with-cairo                    \
                --prefix=$PREFIX                \
                --enable-shared                 \
                --enable-R-shlib                \
                --enable-BLAS-shlib             \
                --disable-R-profiling           \
                --disable-prebuilt-html         \
                --disable-memory-profiling      \
                --with-tk-config=$TK_CONFIG     \
                --with-tcl-config=$TCL_CONFIG   \
                LIBnn=lib
elif [ `uname` == Darwin ]; then

    export DYLD_LIBRARY_PATH=$PREFIX/lib

    echo >> config.site <<EOF
CC=clang
CXX=clang++
F77=gfortran
OBJC=clang
EOF

    ./configure --prefix=$PREFIX                    \
                --with-blas="-framework Accelerate" \
                --with-lapack

fi

make
make install
