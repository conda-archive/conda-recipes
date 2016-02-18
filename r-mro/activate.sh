if [[ -z "$R_HOME" ]]; then
  export R_HOME="${CONDA_ENV_PATH}/R"
  export _CONDA_SET_R_HOME=1
fi
