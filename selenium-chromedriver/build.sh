#!/bin/bash

mkdir -vp ${PREFIX}/bin;

cp -v chromedriver ${PREFIX}/bin/ || exit 1;
chmod -v 755 ${PREFIX}/bin/chromedriver || exit 1;

