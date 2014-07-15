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
    paths=(
        "/lib/x86_64-linux-gnu/libudev.so.1" # Ubuntu, Xubuntu, Mint
        "/usr/lib64/libudev.so.1" # SUSE, Fedora, Arch64
        "/usr/lib/libudev.so.1" # Arch, Fedora 32bit
        "/lib/i386-linux-gnu/libudev.so.1" # Ubuntu 32bit
    )
    for i in "${paths[@]}"; do
        if [ -f $i ]; then
            ln -sf "$i" $PREFIX/node-webkit/libudev.so.0
            break
        fi
    done

    cat <<EOF >$EXEC
#!/bin/sh

# http://stackoverflow.com/questions/59895
LD_LIBRARY_PATH=$PREFIX/node-webkit:\$LD_LIBRARY_PATH $PREFIX/node-webkit/nw "\$@"

EOF
fi

if [ `uname` == Darwin ]; then
    mv ./node-webkit.app/* $PREFIX/node-webkit
    chmod +x $PREFIX/node-webkit/Contents/MacOS/node-webkit
    chmod +x $PREFIX/node-webkit/Contents/Frameworks/node-webkit\ Helper*.app/Contents/MacOS/node-webkit\ Helper*

    cat <<EOF >$EXEC
#!/bin/sh

$PREFIX/node-webkit/Contents/MacOS/node-webkit "\$@"

EOF
fi


chmod +x $EXEC
