#!/bin/bash

npm install --save-optional
npm install grunt -g
grunt uglify
npm uninstall grunt -g

[[ -d "${PREFIX}"/static ]] && rm -rf "${PREFIX}"/static
mkdir -p "${PREFIX}"/static/${PKG_NAME%_static}/${PKG_VERSION}
cp -rf dist/* "${PREFIX}"/static/${PKG_NAME%_static}/${PKG_VERSION}/
