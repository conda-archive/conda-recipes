#!/bin/bash

./configure --prefix="$PREFIX"
make
make install

cd "$PREFIX"
rm -rf share
mv lib/libffi-*/include include

if [ "$(uname -m)" == x86_64 ]; then
    mv lib64/* lib/
    rmdir lib64
fi

# shellcheck disable=SC2016
sed -i s/'includedir=.*'/'includedir=\${exec_prefix}\/include'/g lib/pkgconfig/libffi.pc

