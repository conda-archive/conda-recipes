#!/bin/bash

MACHINE="$(uname 2>/dev/null)"

LinuxInstallation() {
    # Build dependencies:
    # - java-1.6.0-openjdk-devel

    local javaVersion=''
    local pkgBaseDir="${PKG_NAME}-${PKG_VERSION}"
    local aliasPkgBaseDir="${PKG_NAME}"
    local fullPkgBaseDir="${PREFIX}/share/${pkgBaseDir}"
    local fullAliasPkgBaseDir="${PREFIX}/share/${aliasPkgBaseDir}"
    local launchWrapperName="launch-symlink"
    local binLaunchWrapper="${fullPkgBaseDir}/bin/${launchWrapperName}"
    local pkgRelBinPath="../share/${aliasPkgBaseDir}/bin"

    shopt -s extglob;

    ${RECIPE_DIR}/latest-java-detector.sh;
    if [[ ${?} -eq 1 ]]; then
        ${RECIPE_DIR}/latest-java-detector.sh -d;
        if [[ ${?} -eq 1 ]]; then
            echo -e "Unable to setup JAVA_HOME and/or JRE_HOME in built environment";
            exit 1;
        else
            export JAVA_HOME="$(${RECIPE_DIR}/latest-java-detector.sh -d| grep 'export JAVA_HOME='| cut -d '=' -f 2)"
            export JRE_HOME="$(${RECIPE_DIR}/latest-java-detector.sh -d| grep 'export JRE_HOME='| cut -d '=' -f 2)"
        fi
    fi

    mkdir -vp ${PREFIX}/bin || exit 1;
    mkdir -vp ${PREFIX}/share || exit 1;
    mkdir -vp ${fullPkgBaseDir} || exit 1;

    pushd ${PREFIX}/share || exit 1;
    ln -sv ${pkgBaseDir} ${aliasPkgBaseDir} || exit  1;
    popd || exit 1;

    mv -v ${SRC_DIR}/* ${fullPkgBaseDir}/ || exit 1;

    pushd ${fullPkgBaseDir}/bin || exit 1;
    chmod -v 755 *;

    cp -v ${RECIPE_DIR}/latest-java-detector.sh ${PREFIX}/bin/ || exit 1;

    for bin in ${binLaunchWrapper}; do
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

latest-java-detector.sh;
if [[ \${?} -eq 1 ]]; then
    latest-java-detector.sh -d;
    if [[ \${?} -eq 1 ]]; then
        echo -e "Unable to setup JAVA_HOME and/or JRE_HOME in environment" && exit 1;
    else
        export JAVA_HOME="\$(latest-java-detector.sh -d| grep 'export JAVA_HOME='| cut -d '=' -f 2)"
        export JRE_HOME="\$(latest-java-detector.sh -d| grep 'export JRE_HOME='| cut -d '=' -f 2)"
    fi
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

    return 0;
}

case ${MACHINE} in
    'Linux'|'Darwin')
        LinuxInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${MACHINE}";
        exit 1;
        ;;
esac
