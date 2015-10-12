#!/bin/bash

mkdir -p $PREFIX/bin
curl -o $PREFIX/bin/lein 'https://raw.githubusercontent.com/technomancy/leiningen/2.4.2/bin/lein'
chmod a+x $PREFIX/bin/lein
$PREFIX/bin/lein