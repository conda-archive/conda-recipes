#!/bin/bash

declare -a _extra_config

if [[ $(uname) == Darwin ]]; then
  _extra_config+=(--with-libiconv=yes)
  export LDFLAGS=$LDFLAGS" -L${PREFIX}/lib"
  export CFLAGS=$CFLAGS" -I${PREFIX}/include"
  export DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib
fi

LIBFFI_CFLAGS="-I$PREFIX/include" \
LIBFFI_LIBS="-L$PREFIX/lib -lffi" \
  ./configure --prefix="$PREFIX" --disable-libmount "${_extra_config[@]}"
make || exit 1
make install || exit 1
cd $PREFIX
sed -i.bak 's|lib/../lib64|lib|g' lib/*.la lib/pkgconfig/*.pc
rm lib/*.la.bak lib/pkgconfig/*.pc.bak
# The glib build system compiles these.
# (meta.yaml must also refer to them in
# build/skip_compile_pyc)
rm -rf share/glib-2.0/codegen/*.pyc
rm -rf share/glib-2.0/*.pyc
rm -rf share/glib-2.0/gdb/*.pyc
rm -rf share/gdb/auto-load/*
