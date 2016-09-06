#!/bin/bash

npm install --save-optional
npm install grunt@0.4.1
./node_modules/.bin/grunt build uglify

[[ -d "${PREFIX}"/static ]] && rm -rf "${PREFIX}"/static
mkdir -p "${PREFIX}"/static/${PKG_NAME%_static}/${PKG_VERSION}
cp -rf dist/* "${PREFIX}"/static/${PKG_NAME%_static}/${PKG_VERSION}/
