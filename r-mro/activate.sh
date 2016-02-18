if [[ -z "$R_HOME" ]]; then
  DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  export R_HOME="${DIR}/../../../R"
  export _CONDA_SET_R_HOME=1
fi
