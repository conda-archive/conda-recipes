#!/bin/bash

mkdir -vp ${PREFIX}/bin;

POST_LINK="${PREFIX}/bin/.rproject-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};

ARCH="$(uname 2>/dev/null)"

export CFLAGS="-m64 -pipe -O2 -march=x86-64"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib -L${PREFIX}/lib64"

LinuxInstallation() {
    # Build dependencies:
    # - libX11
    # - libX11-devel
    # - libXt
    # - libXt-devel
    # - chrpath

    local files_list="src/scripts/R.sh src/scripts/R.fe"
    local file=""
    local line_num=42
    local pattern=""

    declare -a patterns_list=(
        'export R_DOC_DIR="${R_HOME}/doc"'
        'export R_INCLUDE_DIR="${R_HOME}/include"'
        'export R_SHARE_DIR="${R_HOME}/share"'
        'export R_HOME="${R_HOME_DIR}"'
        'export R_HOME_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/../lib64/R"'
    )

    chmod +x configure;

    ./configure \
        --enable-R-shlib \
        --with-readline=no \
        --with-tcl-config=${PREFIX}/lib/tclConfig.sh \
        --with-tk-config=${PREFIX}/lib/tkConfig.sh \
        --x-includes=/usr/include/X11 \
        --x-libraries=/usr/lib64/ \
        --prefix ${PREFIX} || return 1;
    make || return 1;

    for file in ${files_list}; do
        for pattern in "${patterns_list[@]}"; do
            sed -i ${line_num}i"${pattern}" ${SRC_DIR}/${file} || return 1;
        done
    done

    make install || return 1;

    rm -v ${PREFIX}/lib64/R/bin/R || return 1;
    mv -v ${PREFIX}/bin/R ${PREFIX}/lib64/R/bin/R || return 1;

    pushd ${PREFIX}/bin || return 1;
    ln -vs ../lib64/R/bin/R R || return 1;
    popd || return 1;

    pushd ${PREFIX}/lib64/R || return 1;
    ln -vs ../../lib64 lib64 || return 1;
    popd || return 1;

    pushd ${PREFIX}/lib64 || return 1;
    ln -vs R/lib/libR.so . || return 1;
    ln -vs R/lib/libRlapack.so . || return 1;
    ln -vs R/lib/libRblas.so . || return 1;
    popd || return 1;

    return 0;
}

case ${ARCH} in
    'Linux')
        LinuxInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${ARCH}";
        exit 1;
        ;;
esac

