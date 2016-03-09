R_HOME=$PREFIX/lib/R

Darwin() {
    pkgutil --expand rro.pkg $SRC_DIR/pkg

    cd $SRC_DIR/pkg/R.frame.pkg
    tar xf Payload

    #apply OSX patch
    OLD_PWD=$PWD
    cd $SRC_DIR
    patch -p0 < $RECIPE_DIR/osx_R.patch
    cd $OLD_PWD

    cp R.framework/COPYING $SRC_DIR
    cd R.framework/Versions/Current/Resources
    unlink lib/libreadline*
    
    #mkdir -p $PREFIX/R/library
    #mkdir -p $PREFIX/R/modules
    #cp -Rv bin $PREFIX/R
    #cp -Rv include $PREFIX/R
    #cp -Rv lib $PREFIX/R
    #cp -Rv library $PREFIX/R
    #cp -Rv modules $PREFIX/R
    #cp -Rv share $PREFIX/R

    mkdir -p ${R_HOME}
    cp -Rv . ${R_HOME}

    mkdir -p $PREFIX/bin
    ln -s ${R_HOME}/bin/R $PREFIX/bin/R
    ln -s ${R_HOME}/bin/Rscript $PREFIX/bin/Rscript

    #cd $SRC_DIR/R-src
    #./configure 'CC=clang' 'CXX=clang++' 'OBJC=clang' 'CFLAGS=-Wall -mtune=core2 -g -O2' 'CXXFLAGS=-Wall -mtune=core2 -g -O2' 'OBJCFLAGS=-Wall -mtune=core2 -g -O2' '--with-lapack' '--with-system-zlib' '--enable-memory-profiling' "CPPFLAGS=-I/usr/local/include -I/usr/local/include/freetype2 -I/opt/X11/include -DPLATFORM_PKGTYPE='\"mac.binary.mavericks\"'" '--x-libraries=/opt/X11/lib' '--x-includes=/opt/X11/include/' '--with-libtiff=yes' 'LDFLAGS=-L/opt/X11/lib -L/usr/local/lib /usr/local/lib/libcairo.a /usr/local/lib/libpixman-1.a /usr/local/lib/libfreetype.a /usr/local/lib/libfontconfig.a -lxml2 /usr/local/lib/libreadline.a'
    #make
    #make install
}


Linux() {
    ln -s $PREFIX/lib $PREFIX/lib64
    cd $SRC_DIR/R-src
    patch -p1 -i $SRC_DIR/RRO-src/patches/relocatable_r.patch
    mkdir rd64 && cd rd64
    # Prevent autotools using the system readline
    CPPFLAGS=-B${PREFIX} LDFLAGS=-L${PREFIX}/lib \
    ../configure --prefix=$PREFIX --enable-R-shlib --with-tcltk --with-cairo --with-libpng  \
                --with-libtiff --with-x=yes --with-lapack --enable-BLAS-shlib  LIBR="-lpthread" \
                --enable-memory-profiling

    make
    make install
    (cd $PREFIX && patch -p1 -i $RECIPE_DIR/MakeConf.patch)
    (cd $PREFIX && patch -p1 -i $RECIPE_DIR/R.patch)

    # Copy MRO files
    cp $SRC_DIR/RRO-src/files/OSX/Rprofile.site ${R_HOME}/etc

    # Install the MRO checkpoint package
    git clone https://github.com/RevolutionAnalytics/checkpoint.git $SRC_DIR/checkpoint
    cd $SRC_DIR/checkpoint
    git checkout 0.3.15
    mkdir -p ${R_HOME}/library/checkpoint
    cp -r * ${R_HOME}/library/checkpoint

    # Remove R and Rscript from bin/
    rm $PREFIX/bin/R
    rm $PREFIX/bin/Rscript
    ln -s ${R_HOME}/bin/R $PREFIX/bin/R
    ln -s ${R_HOME}/bin/Rscript $PREFIX/bin/Rscript
    unlink $PREFIX/lib64
}

case `uname` in
    Darwin)
        Darwin
        ;;
    Linux)
        Linux
        ;;
esac

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/activate.sh $ACTIVATE_DIR/r-activate.sh
cp $RECIPE_DIR/deactivate.sh $DEACTIVATE_DIR/r-deactivate.sh
