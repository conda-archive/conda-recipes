#!/bin/bash

echo "Hello from post-link: $PREFIX."

# we have to append
cat <<EOF >>${PREFIX}/.messages.txt
This is an install message from the sample pycosat package
EOF
