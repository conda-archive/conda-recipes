#!/bin/sh

BIN=$PREFIX/bin
EXEC=$BIN/atomshell

mkdir -p $BIN
mkdir -p $SP_DIR/atomshell

if [[ (`uname` == Linux) ]]; then
    mkdir $PREFIX/atom-shell
    mv ./* $PREFIX/atom-shell
    chmod +x $PREFIX/atom-shell/atom

    cat <<EOF >$EXEC
#!/bin/sh

$PREFIX/atom-shell/atom "\$@"

EOF
fi

if [ `uname` == Darwin ]; then
    # XXX THIS IS A HACK XXX
    rm 'atom-shell/Atom.app/Contents/Frameworks/Atom Framework.framework/Frameworks'
    rm 'atom-shell/Atom.app/Contents/Frameworks/Atom Framework.framework/Libraries/Libraries'

    mv atom-shell/Atom.app $PREFIX/atom-shell

    cat <<EOF >$EXEC
#!/bin/sh

$PREFIX/atom-shell/Contents/MacOS/Atom "\$@"

EOF
fi


chmod +x $EXEC
