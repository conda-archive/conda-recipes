#!/bin/bash

MACHINE="$(uname 2>/dev/null)"

export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

export SCALA_HOME="${PREFIX}/share/scala"

export SPARK_HADOOP_VERSION="2.4.0"

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
    local sbinLaunchWrapper="${fullPkgBaseDir}/sbin/${launchWrapperName}"
    local pkgRelBinPath="../share/${aliasPkgBaseDir}/bin"
    local pkgRelSbinPath="../share/${aliasPkgBaseDir}/sbin"

    shopt -s extglob;

    ${RECIPE_DIR}/latest-java-linux-detector.sh;
    if [[ ${?} -eq 1 ]]; then
        ${RECIPE_DIR}/latest-java-linux-detector.sh -d;
        if [[ ${?} -eq 1 ]]; then
            echo -e "Unable to setup JAVA_HOME and/or JRE_HOME in built environment";
            exit 1;
        else
            export JAVA_HOME="$(${RECIPE_DIR}/latest-java-linux-detector.sh -d| grep 'export JAVA_HOME='| cut -d '=' -f 2)"
            export JRE_HOME="$(${RECIPE_DIR}/latest-java-linux-detector.sh -d| grep 'export JRE_HOME='| cut -d '=' -f 2)"
        fi
    fi

    # Bug: https://issues.apache.org/jira/browse/SPARK-1911
    javaVersion="$(${JAVA_HOME}/bin/java -version 2>&1|grep '^java version'|cut -d '"' -f 2)"

    if [[ ! ${javaVersion} =~ 1.6.+([0-9])* ]]; then
        cat <<NEWEOF
    Sorry but currently (due to the bug: https://issues.apache.org/jira/browse/SPARK-1911) your java version is NOT supported!

    Your java version:     ${javaVersion}
    Required java version: 1.6.X

    Please do one of:
    a) remove from your system all newer java's versions than 1.6.X (if You are using latest-java-linux-detector.sh),
    b) manually setup JAVA_HOME and JRE_HOME to 1.6.X version of java.
NEWEOF
        exit 1;
    fi

    mkdir -vp ${PREFIX}/bin || exit 1;
    mkdir -vp ${PREFIX}/share || exit 1;
    mkdir -vp ${fullPkgBaseDir} || exit 1;

    pushd ${PREFIX}/share || exit 1;
    ln -sv ${pkgBaseDir} ${aliasPkgBaseDir} || exit  1;
    popd || exit 1;

    cp -v ${RECIPE_DIR}/latest-java-linux-detector.sh ${PREFIX}/bin/ || exit 1;

    # Build package by using sbt tool (however, there is no target to create distribution - this is mostly for local usage):
    #./sbt/sbt assembly || return 1;
    #./sbt/sbt test || return 1;
    #./bin/run-example org.apache.spark.examples.SparkLR local[2] || return 1;

    # Build package by using specially preapared script:
    ./make-distribution.sh --tgz || return 1;
    tar --strip-components=1 -xvpf ${pkgBaseDir}*.tgz -C ${fullPkgBaseDir}/ || return 1;

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

latest-java-linux-detector.sh;
if [[ \${?} -eq 1 ]]; then
    latest-java-linux-detector.sh -d;
    if [[ \${?} -eq 1 ]]; then
        echo -e "Unable to setup JAVA_HOME and/or JRE_HOME in environment" && exit 1;
    else
        export JAVA_HOME="\$(latest-java-linux-detector.sh -d| grep 'export JAVA_HOME='| cut -d '=' -f 2)"
        export JRE_HOME="\$(latest-java-linux-detector.sh -d| grep 'export JRE_HOME='| cut -d '=' -f 2)"
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

