#!/bin/bash

CHOST="${cpu_arch}-${vendor}-linux-uclibcgnueabi"
mkdir -p .build/src
mkdir -p .build/tarballs

# Necessary because crosstool-ng looks in the wrong location for this one.
if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/linux-3.2.43.tar.xz" ]]; then
    curl -L https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.43.tar.xz -o ${SYS_PREFIX}/conda-bld/src_cache/linux-3.2.43.tar.xz
fi

# Necessary because uclibc let their certificate expire.
if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/uClibc-0.9.33.2.tar.xz" ]]; then
    curl -L --insecure https://www.uclibc.org/downloads/uClibc-0.9.33.2.tar.xz -o ${SYS_PREFIX}/conda-bld/src_cache/uClibc-0.9.33.2.tar.xz
fi

# Necessary because CentOS5.11 is having some certificate issues.
if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/duma_2_5_15.tar.gz" ]]; then
    curl -L --insecure https://dronedata.dl.sourceforge.net/project/duma/duma/2.5.15/duma_2_5_15.tar.gz -o ${SYS_PREFIX}/conda-bld/src_cache/duma_2_5_15.tar.gz
fi

# Ditto.
if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/expat-2.2.0.tar.bz2" ]]; then
    curl -L --insecure https://dronedata.dl.sourceforge.net/project/expat/expat/2.2.0/expat-2.2.0.tar.bz2 -o ${SYS_PREFIX}/conda-bld/src_cache/expat-2.2.0.tar.bz2
fi

if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/gmp-6.1.2.tar.bz2" ]]; then
    curl -L --insecure https://ftp.gnu.org/pub/gnu/gmp/gmp-6.1.2.tar.bz2 -o ${SYS_PREFIX}/conda-bld/src_cache/gmp-6.1.2.tar.bz2
fi

BUILD_NCPUS=4
if [ "$(uname)" == "Linux" ]; then
  BUILD_NCPUS=$(grep -c ^processor /proc/cpuinfo)
elif [ "$(uname)" == "Darwin" ]; then
  BUILD_NCPUS=$(sysctl -n hw.ncpu)
elif [ "$OSTYPE" == "msys" ]; then
  BUILD_NCPUS=${NUMBER_OF_PROCESSORS}
fi

# If dirty is unset or the g++ binary doesn't exist yet, then run ct-ng
if [[ ! -e "${SRC_DIR}/gcc_built/bin/${CHOST}-g++" ]]; then
    bash ${RECIPE_DIR}/write_ctng_config
    cp .config .config.emitted
    sed -i.bak "s|CT_PARALLEL_JOBS=4|CT_PARALLEL_JOBS=${BUILD_NCPUS}|g" .config
    rm .config.bak
    # building oldconfig will ensure that the build platform specific crosstool-ng
    # configuration values (e.g. CT_CONFIGURE_has_stat_flavor_GNU) get mixed with
    # the host platform .config file.
    yes "" | ct-ng oldconfig
    cat .config | grep CT_DISABLE_MULTILIB_LIB_OSDIRNAMES=y || exit 1
    cat .config | grep CT_CC_GCC_USE_LTO=y || exit 1
    # Not sure why this is getting set to y since it depends on ! STATIC_TOOLCHAIN
    sed -i.bak "s|CT_CC_GCC_ENABLE_PLUGINS=y|CT_CC_GCC_ENABLE_PLUGINS=n|g" .config
    if [[ $(uname) == Darwin ]]; then
        sed -i.bak "s|CT_WANTS_STATIC_LINK=y|CT_WANTS_STATIC_LINK=n|g" .config
        rm .config.bak
        sed -i.bak "s|CT_CC_GCC_STATIC_LIBSTDCXX=y|CT_CC_GCC_STATIC_LIBSTDCXX=n|g" .config
        rm .config.bak
        sed -i.bak "s|CT_STATIC_TOOLCHAIN=y|CT_STATIC_TOOLCHAIN=n|g" .config
        rm .config.bak
        sed -i.bak "s|CT_BUILD=\"x86_64-pc-linux-gnu\"|CT_BUILD=\"x86_64-apple-darwin11\"|g" .config
        rm .config.bak
        cat .config | grep CT_BUILD
    fi
#    while [[ 1 == 1 ]]; do
#      echo "Debug this $(pwd)"
#      echo "Debug this ${PATH}"
#      sleep 5
#    done
    unset CFLAGS CXXFLAGS LDFLAGS
    ct-ng build
fi

# increase stack size to prevent test failures
# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31827
if [[ $(uname) == Linux ]]; then
  ulimit -s 32768
fi

# pushd .build/${CHOST}/build/build-cc-gcc-final
# make -k check || true
# popd

# .build/src/gcc-${PKG_VERSION}/contrib/test_summary

find . -name "*activate*.sh" -exec sed -i.bak "s|@CHOST@|${CHOST}|g" "{}" \;
find . -name "*activate*.sh.bak" -exec sed rm "{}" \;

chmod -R u+w ${SRC_DIR}/gcc_built

# Next problem: macOS targetting uClibc ends up with broken symlinks in sysroot/usr/lib:
if [[ $(uname) == Darwin ]]; then
  pushd ${SRC_DIR}/gcc_built/${CHOST}/sysroot/usr/lib
  links=$(find . -type l | cut -c 3-)
  for link in ${links}; do
    target=$(readlink ${link} | sed 's#^/##' | sed 's#//#/#')
    rm ${link}
    ln -s ${target} ${link}
  done
  popd
fi
