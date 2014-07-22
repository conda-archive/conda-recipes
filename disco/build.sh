#!/bin/bash

sed -i "s:sysconfdir    = /etc:sysconfdir = $PREFIX/etc:g" Makefile
sed -i "s:prefix        = /usr/local:prefix = $PREFIX:g" Makefile

make
make install

sed -i "s:/etc/disco/:$PREFIX/etc/disco/:g" \
    $PREFIX/lib/python2.7/site-packages/disco/settings.py

mkdir -p $PREFIX/var/disco
cp $RECIPE_DIR/disco.bashrc $PREFIX/var/disco/.bashrc

mkdir -p $PREFIX/etc/init.d
cp $RECIPE_DIR/init.d $PREFIX/etc/init.d/disco
cp $RECIPE_DIR/create-disco-user.sh $PREFIX/etc/disco/

sed -i "s:\$PREFIX:$PREFIX:g" \
    $PREFIX/var/disco/.bashrc \
    $PREFIX/etc/init.d/disco \
    $PREFIX/etc/disco/create-disco-user.sh

chmod +x $PREFIX/etc/init.d/disco \
    $PREFIX/etc/disco/create-disco-user.sh
