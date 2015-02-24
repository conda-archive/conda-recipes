if [ `uname` == Linux ]; then
    export QMAKESPEC="linux-g++"
fi

if [ `uname` == Darwin ]; then
    export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib/
fi

$PYTHON configure.py \
          --verbose \
          --confirm-license \
          --bindir=$PREFIX/bin \
          --destdir=$SP_DIR

make
make install
