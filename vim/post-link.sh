#!/bin/bash

cd $PREFIX/bin

cat <<EOF > set_vim_path.sh
x=$PATH
env=${x%%:*}
bad_path="bin/"
share="share/vim/vim74/"
new_env=${env/bin/$share}
export VIMRUNTIME=$new_env
EOF

chmod +x ./set_vim_path.sh

