# Generated from configure on the build machine, and then modified to pick up
# the shared libraries in /usr/local (which is replaced with $PREFIX)

cp $RECIPE_DIR/config.mk.linux config.mk
sed -i -e "s:/usr/local:$PREFIX:g" config.mk

make
make install
