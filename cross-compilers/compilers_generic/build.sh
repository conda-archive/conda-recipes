#!/bin/bash

mkdir -p .build/src
mkdir -p .build/tarballs

# Some kernels are not on kernel.org, such as the CentOS 5.11 one used (and heavily patched) by RedHat.
if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/linux-${ctng_kernel}.tar.bz2" ]] && \
   [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/linux-${ctng_kernel}.tar.xz" ]]; then
  if [[ ${ctng_kernel} == 2.6.* ]]; then
    curl -L ftp://ftp.be.debian.org/pub/linux/kernel/v2.6/linux-${ctng_kernel}.tar.bz2 -o ${SYS_PREFIX}/conda-bld/src_cache/linux-${ctng_kernel}.tar.bz2
  elif [[ ${ctng_kernel} == 3.* ]]; then
    # Necessary because crosstool-ng looks in the wrong location for this one.
    curl -L https://www.kernel.org/pub/linux/kernel/v3.x/linux-${ctng_kernel}.tar.bz2 -o ${SYS_PREFIX}/conda-bld/src_cache/linux-${ctng_kernel}.tar.bz2
  elif [[ ${ctng_kernel} == 4.* ]]; then
    curl -L https://www.kernel.org/pub/linux/kernel/v4.x/linux-${ctng_kernel}.tar.xz -o ${SYS_PREFIX}/conda-bld/src_cache/linux-${ctng_kernel}.tar.xz
  fi
fi

# Necessary because uclibc let their certificate expire, this is a bit hacky.
if [[ ${ctng_libc} == uClibc ]]; then
  if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/uClibc-${ctng_uClibc}.tar.xz" ]]; then
      curl -L --insecure https://www.uclibc.org/downloads/uClibc-${ctng_uClibc}.tar.xz -o ${SYS_PREFIX}/conda-bld/src_cache/uClibc-${ctng_uClibc}.tar.xz
  fi
else
  if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/glibc-${gnu}.tar.bz2" ]]; then
      curl -L --insecure https://ftp.gnu.org/gnu/libc/glibc-${gnu}.tar.bz2 -o ${SYS_PREFIX}/conda-bld/src_cache/glibc-${gnu}.tar.bz2
  fi
fi

# Necessary because CentOS5.11 is having some certificate issues.
if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/duma_${ctng_duma//./_}.tar.gz" ]]; then
    curl -L --insecure https://sourceforge.net/projects/duma/files/duma/${ctng_duma}/duma_${ctng_duma//./_}.tar.gz/download -o ${SYS_PREFIX}/conda-bld/src_cache/duma_${ctng_duma//./_}.tar.gz
fi

if [[ ! -e "${SYS_PREFIX}/conda-bld/src_cache/expat-2.2.0.tar.bz2" ]]; then
    curl -L --insecure https://sourceforge.net/projects/expat/files/expat/2.2.0/expat-2.2.0.tar.bz2/download -o ${SYS_PREFIX}/conda-bld/src_cache/expat-2.2.0.tar.bz2
fi


BUILD_NCPUS=4
if [ "$(uname)" == "Linux" ]; then
  BUILD_NCPUS=$(grep -c ^processor /proc/cpuinfo)
elif [ "$(uname)" == "Darwin" ]; then
  BUILD_NCPUS=$(sysctl -n hw.ncpu)
elif [ "$OSTYPE" == "msys" ]; then
  BUILD_NCPUS=${NUMBER_OF_PROCESSORS}
fi

[[ -d ${SRC_DIR}/gcc_built ]] || mkdir -p ${SRC_DIR}/gcc_built

# If the gfortran binary doesn't exist yet, then run ct-ng
if [[ ! -n $(find ${SRC_DIR}/gcc_built -iname ${ctng_cpu_arch}-${ctng_vendor}-*-gfortran) ]]; then
    source ${RECIPE_DIR}/write_ctng_config

    yes "" | ct-ng ${ctng_sample}
    write_ctng_config_before .config
    # Apply some adjustments for conda.
    sed -i.bak "s|# CT_DISABLE_MULTILIB_LIB_OSDIRNAMES is not set|CT_DISABLE_MULTILIB_LIB_OSDIRNAMES=y|g" .config
    sed -i.bak "s|CT_CC_GCC_USE_LTO=n|CT_CC_GCC_USE_LTO=y|g" .config
    cat .config | grep CT_DISABLE_MULTILIB_LIB_OSDIRNAMES=y || exit 1
    cat .config | grep CT_CC_GCC_USE_LTO=y || exit 1
    # Not sure why this is getting set to y since it depends on ! STATIC_TOOLCHAIN
    if [[ ${ctng_nature} == static ]]; then
      sed -i.bak "s|CT_CC_GCC_ENABLE_PLUGINS=y|CT_CC_GCC_ENABLE_PLUGINS=n|g" .config
    fi
    if [[ $(uname) == Darwin ]]; then
        sed -i.bak "s|CT_WANTS_STATIC_LINK=y|CT_WANTS_STATIC_LINK=n|g" .config
        sed -i.bak "s|CT_CC_GCC_STATIC_LIBSTDCXX=y|CT_CC_GCC_STATIC_LIBSTDCXX=n|g" .config
        sed -i.bak "s|CT_STATIC_TOOLCHAIN=y|CT_STATIC_TOOLCHAIN=n|g" .config
        sed -i.bak "s|CT_BUILD=\"x86_64-pc-linux-gnu\"|CT_BUILD=\"x86_64-apple-darwin11\"|g" .config
    fi
    # Now ensure any changes we made above pull in other requirements by running oldconfig.
    yes "" | ct-ng oldconfig
    # Now filter out 'things that cause problems'. For example, depending on the base sample, you can end up with
    # two different glibc versions in-play.
    sed -i.bak '/CT_LIBC/d' .config
    sed -i.bak '/CT_LIBC_GLIBC/d' .config
    # And undo any damage to version numbers => the seds above could be moved into this too probably.
    write_ctng_config_after .config
    if cat .config | grep "CT_GDB_NATIVE=y"; then
      if ! cat .config | grep "CT_EXPAT_TARGET=y"; then
        echo "ERROR: CT_GDB_NATIVE=y but CT_EXPAT_TARGET!=y"
        cat .config
        echo "ERROR: CT_GDB_NATIVE=y but CT_EXPAT_TARGET!=y"
        exit 1
      fi
    fi
    unset CFLAGS CXXFLAGS LDFLAGS
    ct-ng build
fi

# increase stack size to prevent test failures
# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31827
if [[ $(uname) == Linux ]]; then
  ulimit -s 32768
fi

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)

# pushd .build/${CHOST}/build/build-cc-gcc-final
# make -k check || true
# popd

# .build/src/gcc-${PKG_VERSION}/contrib/test_summary

find . -name "*activate*.sh" -exec sed -i.bak "s|@CHOST@|${CHOST}|g" "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@CPPFLAGS@|${FINAL_CPPFLAGS}|g"             "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@CFLAGS@|${FINAL_CFLAGS}|g"                 "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@DEBUG_CFLAGS@|${FINAL_DEBUG_CFLAGS}|g"     "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@CXXFLAGS@|${FINAL_CXXFLAGS}|g"             "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@DEBUG_CXXFLAGS@|${FINAL_DEBUG_CXXFLAGS}|g" "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@DEBUG_CXXFLAGS@|${FINAL_DEBUG_CXXFLAGS}|g" "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@FFLAGS@|${FINAL_FFLAGS}|g"                 "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@DEBUG_FFLAGS@|${FINAL_DEBUG_FFLAGS}|g"     "{}" \;
find . -name "*activate*.sh" -exec sed -i.bak "s|@LDFLAGS@|${FINAL_LDFLAGS}|g"               "{}" \;

find . -name "*activate*.sh.bak" -exec rm "{}" \;

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

exit 0
