#!/bin/bash

chmod +x configure

./configure --disable-maintainer-mode --prefix=$PREFIX

make -j${CPU_COUNT}
make install
