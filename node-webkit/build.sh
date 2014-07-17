#!/bin/sh

BIN=$PREFIX/bin
EXEC=$BIN/node-webkit

mkdir -p $BIN
mkdir -p $SP_DIR/node-webkit
mkdir $PREFIX/node-webkit

if [[ (`uname` == Linux) ]]; then
    mv ./* $PREFIX/node-webkit
    chmod +x $PREFIX/node-webkit/nw
    ln -s /lib/

    # https://github.com/rogerwang/node-webkit/wiki/The-solution-of-lacking-libudev.so.0
    # Simplest workaround
    sed -i 's/udev\.so\.0/udev.so.1/g' $PREFIX/node-webkit/nw

    cat <<EOF >$EXEC
#!/bin/sh

$PREFIX/node-webkit/nw "\$@"

EOF
fi

if [ `uname` == Darwin ]; then
    mv ./node-webkit.app/* $PREFIX/node-webkit
    # Remove Info.plist so OSX doesn't treat node-webkit as its own app
    rm $PREFIX/node-webkit/Contents/Info.plist
    chmod +x $PREFIX/node-webkit/Contents/MacOS/node-webkit
    chmod +x $PREFIX/node-webkit/Contents/Frameworks/node-webkit\ Helper*.app/Contents/MacOS/node-webkit\ Helper*

    cat <<EOF >$EXEC
#!/bin/sh

$PREFIX/node-webkit/Contents/MacOS/node-webkit "\$@"

EOF
fi


chmod +x $EXEC
