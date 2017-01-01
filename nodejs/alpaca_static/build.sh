#!/bin/bash

npm install --user "${USER}"    \
            --python=python2.7  \
            --loglevel warn     \
            .
npm start
npm prune --production
rm -rf $PREFIX/share/man/man1/gulp.1
[[ -d "${PREFIX}"/static ]] && rm -rf "${PREFIX}"/static
mkdir -p "${PREFIX}"/static/${PKG_NAME%_static}/${PKG_VERSION}
cp -rf build/* "${PREFIX}"/static/${PKG_NAME%_static}/${PKG_VERSION}

# OS X installs node-gyp globally for some reason which means it ends up in ${PREFIX}
if [[ -d "${PREFIX}"/lib/node_modules ]]; then
  rm -rf "${PREFIX}"/lib/node_modules
fi

# Seems some other cruft is left lying around ..
if [[ -d "${PREFIX}"/static/tmp ]]; then
  rm -rf "${PREFIX}"/static/tmp
fi

exit 0
