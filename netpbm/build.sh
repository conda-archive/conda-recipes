cp $RECIPE_DIR/Makefile.config.linux Makefile.config
sed -i -e "s:/usr/local:$PREFIX:g" Makefile.config
sed -i -e "s:JPEGLIB = NONE:#JPEGLIB = $PREFIX/lib/libjpeg.so:g" Makefile.config
sed -i -e "s:#JPEGHDR_DIR = $PREFIX/include:JPEGHDR_DIR = $PREFIX/include:g" Makefile.config

make
make install
