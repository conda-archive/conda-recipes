#!/bin/bash

pushd $PREFIX/etc/nginx;

# Re-create config files without hardlinks
for filename in `ls *.default`
do
    cp $filename ${filename%%.default} 
done
popd

cat <<EOF >> ${PREFIX}/.messages.txt
This is an install message from the nginx package.
EOF
