# Remove the crt symlinks created in post-link.sh
find $PREFIX/lib/gcc/*/* -type l | xargs rm

# Remove the gcc specs file we created in post-link.sh
SPECS_DIR=`echo ${PREFIX}/lib/gcc/*/*`
SPECS_FILE=${SPECS_DIR}/specs
rm ${SPECS_FILE}
