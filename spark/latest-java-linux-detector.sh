#!/bin/bash

#############
# VARIABLES #
#############

SCRIPT_NAME="${0}"
CMD="${1}"

LINUX_DISTRO="unknown"

DETERMINED_JAVA_HOME=""
DETERMINED_JRE_HOME=""

#############
# FUNCTIONS #
#############

f_CheckJavaHomeVariable() {
    if [[ -z ${JAVA_HOME} ]]; then
        echo -e "You have NO setup of JAVA_HOME variable!";
        return 1;
    else
        if [[ ! -x ${JAVA_HOME}/bin/java ]]; then
            echo -e "Your JAVA_HOME variable is NOT pointing to right directory with java (no executable bin/java was found there)!";
            return 1;
        fi
    fi

    return 0;
}

f_CheckJreHomeVariable() {
    if [[ -z ${JRE_HOME} ]]; then
        echo -e "You have NO setup of JRE_HOME variable!";
        return 1;
    else
        if [[ ! -x ${JRE_HOME}/bin/java ]]; then
            echo -e "Your JRE_HOME variable is NOT pointing to right directory with java (no executable bin/java was found there)!";
            return 1;
        fi
    fi

    return 0;
}

f_PrintError() {
    var="${1}"
    cmd="${2}"

    cat <<NEWEOF
    Can't determine appropriate value for ${var} variable.
    Probably You have no java installed at all.
    Please run below command and eventually re-run this script:

    $ ${cmd}
NEWEOF

    return 0;
}

f_DetermineLinuxDistro() {
    local distro=''

    which yum &>/dev/null;
    if [[ ${?} -eq 0 ]]; then
        distro='centos'
    else
        which apt-get &>/dev/null;
        if [[ ${?} -eq 0 ]]; then
            distro='debian'
        else
            cat <<NEWEOF
    Sorry but your distribution is not supported.

    The support is available only for distros with:
    a) apt-get package manager
    b) yum package manager

NEWEOF
            exit 1;
        fi
    fi

    export LINUX_DISTRO="${distro}"

    return 0;
}

f_DetermineJavaHome() {
    local determined_java_home=''
    local cmd=''
    local test_java=0

    case ${LINUX_DISTRO} in
        'centos')
            determined_java_home="$(ls -1 /usr/lib/jvm/java-+([0-9]).+([0-9]).+([0-9])/bin/java 2>&1| sort -r| head -n1)"
            cmd="sudo yum install java-1.6.0-openjdk-devel"
            ;;
        'debian')
            determined_java_home="$(ls -1 /usr/lib/jvm/java-+([0-9]).+([0-9]).+([0-9])/bin/java 2>&1| sort -r| head -n1)"
            cmd="sudo apt-get install openjdk-6-jdk"
            ;;
        *)
            echo -e "Internal error!";
            exit 1;
            ;;
    esac

    [[ -z ${determined_java_home} ]] && test_java=1;
    [[ ! -x ${determined_java_home} ]] && test_java=1;

    determined_java_home="${determined_java_home%%/bin/java}"

    if [[ ${test_java} -eq 1 ]]; then
        f_PrintError "JAVA_HOME" "${cmd}" && return 1;
    fi

    export DETERMINED_JAVA_HOME="${determined_java_home}"

    return 0;
}

f_DetermineJreHome() {
    local determined_jre_home=''
    local cmd=''
    local test_jre=0

    case ${LINUX_DISTRO} in
        'centos')
            determined_jre_home="$(ls -1 /usr/lib/jvm/java-+([0-9]).+([0-9]).+([0-9])/jre/bin/java 2>&1| sort -r| head -n1)"
            cmd="sudo yum install jre-1.6.0-openjdk-devel"
            ;;
        'debian')
            determined_jre_home="$(ls -1 /usr/lib/jvm/java-+([0-9]).+([0-9]).+([0-9])-*/jre/bin/java 2>&1| sort -r| head -n1)"
            cmd="sudo apt-get install openjdk-6-jdk"
            ;;
        *)
            echo -e "Internal error!";
            exit 1;
            ;;
    esac

    [[ -z ${determined_jre_home} ]] && test_jre=1;
    [[ ! -x ${determined_jre_home} ]] && test_jre=1;

    determined_jre_home="${determined_jre_home%%/bin/java}"

    if [[ ${test_jre} -eq 1 ]]; then
        f_PrintError "JRE_HOME" "${cmd}" && return 1;
    fi

    export DETERMINED_JRE_HOME="${determined_jre_home}"

    return 0;
}

f_DetermineVariables() {

    f_DetermineJavaHome || return 1;
    f_DetermineJreHome || return 1;

    cat <<NEWEOF
    You should setup in your environment (for example in .bashrc file):

    export JAVA_HOME=${DETERMINED_JAVA_HOME}
    export JRE_HOME=${DETERMINED_JRE_HOME}

NEWEOF

    export JAVA_HOME="${DETERMINED_JAVA_HOME}"
    export JRE_HOME="${DETERMINED_JRE_HOME}"

    return 0;
}

f_TestJava() {
    f_CheckJavaHomeVariable || return 1;
    f_CheckJreHomeVariable || return 1;

    return 0;
}

f_Usage() {

    cat <<NEWEOF
    ${SCRIPT_NAME} [-h|-d]

    -h      Print this help.
    -d      Try to determine appropriate JAVA_HOME and JRE_HOME variables on curent system.

    Without specifying one of above parameters scripts will check if JAVA_HOME and JRE_HOME are
    appropriately setup (if not then appropriately info will be printed and return code equals to 1)
NEWEOF

    return 0;
}

f_Main() {
    shopt -s extglob;

    f_DetermineLinuxDistro;

    if [[ ${CMD} == '-h' ]]; then
        f_Usage;
        return 0;
    elif [[ ${CMD} == '-d' ]]; then
        f_DetermineVariables || return 1;
        return 0;
    fi

    f_TestJava || return 1;

    return 0;
}

########
# MAIN #
########

f_Main ${CMD} || exit 1;
