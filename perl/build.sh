#!/bin/bash

# Build perl
sh Configure -de -Dprefix=$PREFIX -Duserelocatableinc
make
# The next part is commented out because some tests are unreliable on OS X
# make test
make install
