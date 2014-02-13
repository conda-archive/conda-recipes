if [ `uname` == Linux ]; then
    export QMAKESPEC="linux-g++"


    # Work around qt's hard-coded paths
    sudo mkdir -p /opt/anaconda1anaconda2anaconda3/
    sudo chmod 777 /opt/anaconda1anaconda2anaconda3
    ln -s $PREFIX/mkspecs /opt/anaconda1anaconda2anaconda3/mkspecs
    ln -s $PREFIX/include /opt/anaconda1anaconda2anaconda3/include
    ln -s $PREFIX/lib /opt/anaconda1anaconda2anaconda3/lib
    ln -s $PREFIX/bin /opt/anaconda1anaconda2anaconda3/bin

fi

$PYTHON configure-ng.py --verbose \
        --confirm-license \
        --bindir=$PREFIX/bin \
        --destdir=$SP_DIR \

make
make install

if [ `uname` == Linux ]; then
    sudo rm -rf /opt/anaconda1anaconda2anaconda3
fi
