
Darwin() {
    pkgutil --expand rro.pkg $SRC_DIR/pkg

    cd $SRC_DIR/pkg/R.frame.pkg
    tar xf Payload

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
    mkdir pkg && cd pkg
    rpm2cpio ../rro.rpm | cpio -idm

    cd usr/lib64/MRO-3.2.3/R-3.2.3/lib64
    cp -rp R $PREFIX

    cp $SRC_DIR/pkg/usr/lib64/MRO-3.2.3/COPYING $SRC_DIR

}

case `uname` in
    Darwin)
        Darwin
        ;;
    Linux)
        Linux
        ;;
esac
