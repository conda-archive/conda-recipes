if [ `uname` == Darwin ]; then
    export QMAKESPEC="unsupported/macx-clang-libc++"
else
    export QMAKESPEC="linux-g++"
fi

# Work around qt's hard-coded paths
sudo mkdir -p /opt/anaconda1anaconda2anaconda3/
sudo chmod 777 /opt/anaconda1anaconda2anaconda3
ln -s $PREFIX/mkspecs /opt/anaconda1anaconda2anaconda3/mkspecs 

$PYTHON configure.py --verbose \
        --confirm-license \
        --bindir=$PREFIX/bin \
        --destdir=$SP_DIR \



# $PYTHON configure-ng.py --verbose --spec="unsupported/macx-clang-libc++"

make
make install
exit 1
