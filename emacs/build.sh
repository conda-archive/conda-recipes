#!/bin/bash
./configure  --prefix=$PREFIX --without-x

make -j4  && make -j4  install

# # We need a wrapper script because emacs requires certain environment
# # variables to be set to find various things.
# mv $PREFIX/bin/emacs $PREFIX/bin/.emacs
# cp $RECIPE_DIR/start_emacs.sh $PREFIX/bin/emacs
# chmod a+x $PREFIX/bin/emacs
