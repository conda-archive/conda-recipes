#!/bin/sh

mkdir -p $CONDA_ENV_PATH/etc/conda/deactivate.d
mkdir -p $CONDA_ENV_PATH/etc/conda/activate.d
cat <<EOF > $CONDA_ENV_PATH/etc/conda/deactivate.d/openmpi.sh
echo unsetting OPAL_PREFIX
export OPAL_PREFIX=$OPAL_PREFIX_OLD
unset OPAL_PREFIX_OLD
EOF
cat <<EOF > $CONDA_ENV_PATH/etc/conda/activate.d/openmpi.sh
#!/bin/sh
echo setting OPAL_PREFIX to $CONDA_ENV_PATH
export OPAL_PREFIX_OLD=$OPAL_PREFIX
export OPAL_PREFIX=$CONDA_ENV_PATH
EOF

