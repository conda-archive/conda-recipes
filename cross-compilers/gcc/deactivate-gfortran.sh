#!/bin/bash

# The arguments to this are:
# 1. activation nature {activate|deactivate}
# 2. toolchain nature {build|host|ccc}
# 3. machine (should match -dumpmachine)
# 4. prefix (including any final -)
# 5+ program (or environment var comma value)
# The format for 5+ is name{,,value}. If value is specified
#  then name taken to be an environment variable, otherwise
#  it is taken to be a program. In this case, which is used
#  to find the full filename during activation. The original
#  value is stored in environment variable CONDA_BACKUP_NAME
#  For deactivation, the distinction is irrelevant as in all
#  cases NAME simply gets reset to CONDA_BACKUP_NAME.  It is
#  a fatal error if a program is identified but not present.
function _tc_activation() {
  local act_nature=$1; shift
  local tc_nature=$1; shift
  local tc_machine=$1; shift
  local tc_prefix=$1; shift
  local thing
  local newval
  local from
  local to
  local which
  local pass

  if [ "${act_nature}" = "activate" ]; then
    from=""
    to="CONDA_BACKUP_"
  else
    from="CONDA_BACKUP_"
    to=""
  fi

  for pass in check apply; do
    for thing in $tc_nature,$tc_machine "$@"; do
      case "${thing}" in
        *,*)
          newval=$(echo "${thing}" | sed "s,^[^\,]*\,\(.*\),\1,")
          thing=$(echo "${thing}" | sed "s,^\([^\,]*\)\,.*,\1,")
          ;;
        *)
          newval=$(which ${CONDA_PREFIX}/bin/${tc_prefix}${thing} 2>/dev/null)
          if [ -z "${newval}" -a "${pass}" = "check" ]; then
            echo "ERROR: This cross-compiler package contains no program ${CONDA_PREFIX}/bin/${tc_prefix}${thing}"
            return 1
          fi
          ;;
      esac
      if [ "${pass}" = "apply" ]; then
        thing=$(echo ${thing} | tr 'a-z+-' 'A-ZX_')
        eval oldval="\$${from}$thing"
        if [ -n "${oldval}" ]; then
          eval export "${to}'${thing}'=\"${oldval}\""
        else
          eval unset '${to}${thing}'
        fi
        if [ -n "${newval}" ]; then
          eval export "'${from}${thing}=${newval}'"
        else
          eval unset '${from}${thing}'
        fi
      fi
    done
  done
  return 0
}

# We would like to add "-fstack-protector --param=ssp-buffer-size" to {C,CXX}FLAGS
# but uClibc has poor (or no) support for it.
# CHOST is prepended to this file by the install script.
env > /tmp/old-env-$$.txt
_tc_activation \
  deactivate host ${CHOST} ${CHOST}- \
  gfortran \
  "FFLAGS,${FFLAGS:--march=nocona -Wall -Wextra -fopenmp -fPIC -O3}" \
  "FORTRANFLAGS,${FORTRANFLAGS:--march=nocona -Wall -Wextra -fopenmp -fPIC -O3}" \
  "DEBUG_FFLAGS,${DEBUG_FFLAGS:--Og -g -Wall -Wextra -fcheck=all -fbacktrace -fPIC -fimplicit-none}"

if [ $? -ne 0 ]; then
  echo "ERROR: (Pseudo) cross-compiler deactivation failed, see above for details"
#  exit 1
else
  env > /tmp/new-env-$$.txt
  echo "INFO: Deactivating 'x86_64-unknown-linux-gnu-gfortran' (pseudo) cross-compiler made the following environmental changes:"
  diff -U 0 -rN /tmp/old-env-$$.txt /tmp/new-env-$$.txt | tail -n +4 | grep "^-.*\|^+.*" | grep -v "CONDA_BACKUP_" | sort
fi
