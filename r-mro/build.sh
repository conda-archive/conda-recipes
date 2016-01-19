
Darwin() {
    DARWIN_FN="RRO-3.2.2-OSX.pkg"
    pkgutil --expand $DARWIN_FN $SRC_DIR/pkg

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
    LINUX_FN="RRO-3.2.2.el5.x86_64.rpm"
    mkdir pkg && cd pkg
    rpm2cpio ../$LINUX_FN | cpio -idm

}

case `uname` in
    Darwin)
        Darwin
        ;;
    Linux)
        Linux
        ;;
esac
