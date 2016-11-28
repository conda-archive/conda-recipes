#!/bin/sh

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
