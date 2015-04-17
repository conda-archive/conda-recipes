# Generated from configure on the build machine, and then modified to pick up
# the shared libraries in /usr/local (which is replaced with $PREFIX)

cp $RECIPE_DIR/config.mk.linux config.mk
sed -i -e "s:/usr/local:$PREFIX:g" config.mk

make
make package pkgdir=$SRC_DIR/pkg
make check pkgdir=$SRC_DIR/pkg

# The netpbm install script is interactive, so just install it manually
cp -R pkg/bin/* $PREFIX/bin/
cp -R pkg/lib/* $PREFIX/lib/
cp -R pkg/link/* $PREFIX/lib/
cp -R pkg/include/* $PREFIX/include/
cp -R pkg/man/man1/* $PREFIX/share/man1/
cp -R pkg/man/man3/* $PREFIX/share/man3/
cp -R pkg/man/man5/* $PREFIX/share/man5/
cp -R pkg/man/web/* $PREFIX/share/web/
