#!/bin/sh

BIN=$PREFIX/bin
EXEC=$BIN/atomshell

mkdir -p $BIN
mkdir -p $SP_DIR/atomshell
mkdir $PREFIX/atom-shell

if [[ (`uname` == Linux) ]]; then
    mv ./* $PREFIX/atom-shell
    chmod +x $PREFIX/atom-shell/atom

    cat <<EOF >$EXEC
#!/bin/sh

$PREFIX/atom-shell/atom "\$@"

EOF
fi

if [ `uname` == Darwin ]; then
    # XXX THIS IS A HACK XXX
    rm './Atom.app/Contents/Frameworks/Atom Framework.framework/Frameworks'

    mv ./Atom.app/* $PREFIX/atom-shell
    chmod +x $PREFIX/atom-shell/Contents/MacOS/Atom

    cat <<EOF >$EXEC
#!/bin/sh

$PREFIX/atom-shell/Contents/MacOS/Atom "\$@"

EOF
fi


chmod +x $EXEC
