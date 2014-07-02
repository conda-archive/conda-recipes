#!/bin/sh

mkdir -p $SP_DIR/atomshell
cp $RECIPE_DIR/*.py $SP_DIR/atomshell/

if [[ (`uname` == Linux) ]]; then
    wget https://github.com/atom/atom-shell/releases/download/v0.13.3/atom-shell-v0.13.3-linux-x64.zip
    unzip atom-shell-v0.13.3-linux-x64.zip -d atom-shell

    mv atom-shell $SP_DIR/atomshell/atomshell
fi


if [ `uname` == Darwin ]; then
    curl -OL https://github.com/atom/atom-shell/releases/download/v0.13.3/atom-shell-v0.13.3-darwin-x64.zip
    unzip atom-shell-v0.13.3-darwin-x64.zip -d atom-shell

    # XXX THIS IS A HACK XXX
    rm 'atom-shell/Atom.app/Contents/Frameworks/Atom Framework.framework/Frameworks'
    rm 'atom-shell/Atom.app/Contents/Frameworks/Atom Framework.framework/Libraries/Libraries'

    mv atom-shell/Atom.app $SP_DIR/atomshell/atomshell
fi
