#!/bin/bash

# Build perl
sh Configure -de -Dprefix=$PREFIX -Duserelocatableinc
make
# make test
make install

# Install CPAN Minus to make building other packages that rely on this simpler
echo "Installing CPAN Minus"
curl -L http://cpanmin.us | perl - App::cpanminus
