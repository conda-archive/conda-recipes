mkdir "${PREFIX}"/gcc

# Please leave this here. It allows quick build and debug turnaround on Linux.
_DEBUG=0
declare -a extra_config
if [[ "${_DEBUG}" == "1" ]]; then
    extra_config+=(--enable-languages=c)
    extra_config+=(--disable-bootstrap)
fi

if [ "$(uname)" == "Darwin" ]; then
    # On Mac, we expect that the user has installed the xcode command-line utilities (via the 'xcode-select' command).
    # The system's libstdc++.6.dylib will be located in /usr/lib, and we need to help the gcc build find it.
    export LDFLAGS="-Wl,-headerpad_max_install_names -Wl,-L${PREFIX}/lib -Wl,-L/usr/lib"
    export DYLD_FALLBACK_LIBRARY_PATH="${PREFIX}/lib:/usr/lib"

    ./configure \
        --prefix="${PREFIX}" \
        --with-gxx-include-dir="${PREFIX}"/gcc/include/c++ \
        --bindir="${PREFIX}"/bin \
        --datarootdir="${PREFIX}"/share \
        --libdir="${PREFIX}"/lib \
        --with-gmp="${PREFIX}" \
        --with-mpfr="${PREFIX}" \
        --with-mpc="${PREFIX}" \
        --with-isl="${PREFIX}" \
        --with-cloog="${PREFIX}" \
        --with-boot-ldflags="${LDFLAGS}" \
        --with-stage1-ldflags="${LDFLAGS}" \
        --enable-checking=release \
        --with-tune=generic \
        --disable-multilib \
        ${extra_config[@]}
else
    # For reference during post-link.sh, record some
    # details about the OS this binary was produced with.
    mkdir -p "${PREFIX}/share"
	# lsb_release can complain about LSB modules in stderr, so we
	# ignore that.

    lsb_release -a 1> "${PREFIX}"/share/conda-gcc-build-machine-os-details
    if [[ ! -f /usr/lib/crtn.o ]]; then
      if [[ -f /usr/lib64/crtn.o ]]; then
        [[ -d host-x86_64-unknown-linux-gnu/lib/gcc ]] || mkdir -p host-x86_64-unknown-linux-gnu/lib/gcc
        cp -rf /usr/lib64/crt*.o host-x86_64-unknown-linux-gnu/lib/gcc/
        [[ -d "${PREFIX}"/lib ]] || mkdir -p "${PREFIX}"/lib
        cp -rf /usr/lib64/crt*.o "${PREFIX}"/lib
      else
        echo "Fatal: Cannot find crt*.o"
        exit 1
      fi 
    fi

    ./configure \
        --prefix="${PREFIX}" \
        --with-gxx-include-dir="${PREFIX}"/gcc/include/c++ \
        --bindir="${PREFIX}"/bin \
        --datarootdir="${PREFIX}"/share \
        --libdir="${PREFIX}"/lib \
        --with-gmp="${PREFIX}" \
        --with-mpfr="${PREFIX}" \
        --with-mpc="${PREFIX}" \
        --with-isl="${PREFIX}" \
        --with-cloog="${PREFIX}" \
        --enable-checking=release \
        --with-tune=generic \
        --disable-multilib \
        ${extra_config[@]}
fi

if [[ "${_DEBUG}" == "1" ]]; then
    sed -i 's,^STRIP = .*$,STRIP = true,g'                   Makefile
    sed -i 's,^STRIP_FOR_TARGET=.*$,STRIP_FOR_TARGET=true,g' Makefile
    find . -name Makefile -print0 | xargs -0  sed -i 's,-O2,-O0,'
    USED_CXXFLAGS="${CXXFLAGS} -ggdb -O0"
    USED_CFLAGS="${CFLAGS} -ggdb -O0"
    make STAGE1_CXXFLAGS="${USD_CXXFLAGS}" STAGE1_CFLAGS="${USED_CFLAGS}"
    # We don't get debug symbols for main() without this, weird.
    if [[ $(uname -m) == i686 ]]; then
        _BUILDDIR=host-i686-pc-linux-gnu
    else
        _BUILDDIR=x86_64-unknown-linux-gnu
    fi
    pushd ${_BUILDDIR}
        find . -name Makefile -print0 | xargs -0  sed -i 's,-O2,-O0,'
        rm -f gcc.o xgcc xg++
        [[ -f Makefile ]] && make
    popd
    make install
else
    make -j"${CPU_COUNT}"
    make install-strip
fi

# Remove libtool .la files.
find "${PREFIX}" -name '*la' -print0 | xargs -0  rm -f

# Link cc to gcc
(cd "${PREFIX}"/bin && ln -s gcc cc)
