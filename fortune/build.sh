sed -i -e "s:/usr/local:$PREFIX:g" Makefile
if [ `uname` == Darwin ]; then
    sed -i -e "s/DBSD_REGEX/DPOSIX_REGEX/g" Makefile
fi
make install
ln -s ../games/fortune $PREFIX/bin/fortune
