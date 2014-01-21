if [ `uname` == Darwin ]; then
    export QMAKESPEC="unsupported/macx-clang-libc++"
else
    export QMAKESPEC="linux-g++"
fi
$PYTHON configure.py --verbose \
        --confirm-license \
        --bindir=$PREFIX/bin \
        --destdir=$SP_DIR \



# $PYTHON configure-ng.py --verbose --spec="unsupported/macx-clang-libc++"

make
make install
exit 1
