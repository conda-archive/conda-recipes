#!/bin/bash
sh Configure -de -Dprefix=$PREFIX -Duserelocatableinc
make
make test
make install

# Install CPAN Minus to make building other packages that rely on this simpler
curl -L http://cpanmin.us | perl - App::cpanminus