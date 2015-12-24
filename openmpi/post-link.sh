#!/bin/sh

mkdir -p $PREFIX/etc/conda/deactivate.d
mkdir -p $PREFIX/etc/conda/activate.d
cat <<EOF > $PREFIX/etc/conda/deactivate.d/openmpi.sh
echo unsetting OPAL_PREFIX
export OPAL_PREFIX=$OPAL_PREFIX_OLD
unset OPAL_PREFIX_OLD
EOF
cat <<EOF > $PREFIX/etc/conda/activate.d/openmpi.sh
#!/bin/sh
echo setting OPAL_PREFIX to $PREFIX
export OPAL_PREFIX_OLD=$OPAL_PREFIX
export OPAL_PREFIX=$PREFIX
EOF

