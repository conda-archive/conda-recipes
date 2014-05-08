#!/bin/bash

MACHINE="$(uname 2>/dev/null)"

export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

LinuxInstallation() {
    # Build dependencies:
    # - java-1.7.0-openjdk-devel

    local pkgBaseDir="${PKG_NAME}-${PKG_VERSION}-incubating"
    local launchWrapperName="launch-symlink"
    local binLaunchWrapper="${PREFIX}/${pkgBaseDir}/bin/${launchWrapperName}"
    local sbinLaunchWrapper="${PREFIX}/${pkgBaseDir}/sbin/${launchWrapperName}"
    local pkgRelBinPath="../${pkgBaseDir}/bin"
    local pkgRelSbinPath="../${pkgBaseDir}/sbin"

    ./sbt/sbt assembly || return 1;
    ./make-distribution.sh --tgz || return 1;
    tar -xvzpf ${pkgBaseDir}*.tar.gz -C ${PREFIX}/ || return 1;

    for bin in ${binLaunchWrapper} ${sbinLaunchWrapper}; do
        cat > ${bin} <<EOF
#!/bin/bash

SCRIPT_CUR_DIR="\$(dirname "\${0}" 2>/dev/null)"
SCRIPT_REL_DIR="\$(dirname "\$(readlink "\${0}" 2>/dev/null)" 2>/dev/null)"
SCRIPT_DIR="\$(cd "\${SCRIPT_CUR_DIR}/\${SCRIPT_REL_DIR}" 2>/dev/null && pwd -P 2>/dev/null)"
SCRIPT_FILE_NAME="\$(basename "\${0}" 2>/dev/null)"
SCRIPT_FILE="\${SCRIPT_DIR}/\${SCRIPT_FILE_NAME}"

if [[ ! -d \${SCRIPT_DIR} ]]; then
    echo -e "Problem with launch-wrapper, no directory was found: \${SCRIPT_DIR}" && exit 1;
fi
if [[ ! -f \${SCRIPT_FILE} ]]; then
    echo -e "Problem with launch-wrapper, no file was found: \${SCRIPT_FILE}" && exit 1;
fi

echo -e "\nlaunch-wrapper:"
echo -e "\tRunning   -> \${SCRIPT_FILE}";
echo -e "\tWith args -> \${@}";
echo -e "";

"\${SCRIPT_FILE}" "\${@}"
EOF
        chmod -v 755 ${bin} || return 1;
    done

    ### Setup bin

    pushd ${PREFIX}/bin || return 1;

    for filePath in ${pkgRelBinPath}/*; do
        fileName="$(basename "${filePath}" 2>/dev/null)"

        if [[ ${fileName} == ${launchWrapperName} ]]; then
            continue;
        fi
        ln -vs ${pkgRelBinPath}/${launchWrapperName} ${fileName} || return 1;
    done

    popd || return 1;

    ### Setup wrapper for sbin

    pushd ${PREFIX}/bin || return 1;

    for filePath in ${pkgRelSbinPath}/*; do
        fileName="$(basename "${filePath}" 2>/dev/null)"

        if [[ ${fileName} == ${launchWrapperName} ]]; then
            continue;
        fi
        ln -vs ${pkgRelSbinPath}/${launchWrapperName} ${fileName} || return 1;
    done

    popd || return 1;

    return 0;
}

case ${MACHINE} in
    'Linux')
        LinuxInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${MACHINE}";
        exit 1;
        ;;
esac

