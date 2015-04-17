cp $RECIPE_DIR/Makefile.config.linux Makefile.config
sed -i -e "s:/usr/local:$PREFIX:g" Makefile.config

make
make install
