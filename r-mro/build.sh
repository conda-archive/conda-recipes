
Darwin() {
    pkgutil --expand rro.pkg $SRC_DIR/pkg

    cd $SRC_DIR/pkg/R.frame.pkg
    tar xf Payload

    cp R.framework/COPYING $SRC_DIR
    cd R.framework/Versions/Current/Resources
    unlink lib/libreadline*
    
    mkdir -p $PREFIX/R/library
    mkdir -p $PREFIX/R/modules
    cp -Rv bin $PREFIX
    cp -Rv include $PREFIX
    cp -Rv lib $PREFIX/lib
    cp -Rv library $PREFIX/R/library
    cp -Rv modules $PREFIX/R/modules
    cp -Rv share $PREFIX
}


Linux() {

    cd $SRC_DIR/R-src
    patch -p1 -i $SRC_DIR/RRO-src/patches/relocatable_r.patch
    ./configure --prefix=$PREFIX --enable-R-shlib --with-tcltk --with-cairo --with-libpng  \
                --with-libtiff --with-x=yes --with-lapack --enable-BLAS-shlib  LIBR="-lpthread" \
                --enable-memory-profiling

    make
    make install
    mv $PREFIX/lib64/R $PREFIX/R

    # Copy MRO files
    cp $SRC_DIR/RRO-src/files/OSX/Rprofile.site $PREFIX/R/etc

    # Install the MRO checkpoint package
    git clone https://github.com/RevolutionAnalytics/checkpoint.git $SRC_DIR/checkpoint
    cd $SRC_DIR/checkpoint
    git checkout 0.3.15
    mkdir -p $PREFIX/R/library/checkpoint
    cp -r * $PREFIX/R/library/checkpoint
}

case `uname` in
    Darwin)
        Darwin
        ;;
    Linux)
        Linux
        ;;
esac
