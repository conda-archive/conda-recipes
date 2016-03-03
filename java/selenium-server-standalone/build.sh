#!/bin/bash

# Dependencies:
# - Appropriately setup JAVA_HOME variable in system.

LCL_PKG_FULL_NAME="${PKG_NAME}-${PKG_VERSION}.jar"

mkdir -vp ${PREFIX}/bin;
mkdir -vp ${PREFIX}/share;

cp -v ${SRC_DIR}/${LCL_PKG_FULL_NAME} ${PREFIX}/share/ || exit 1;

cat > ${PREFIX}/bin/selenium-server-standalone <<EOF
#!/bin/bash

SCRIPT_CUR_DIR="\$(dirname "\${0}" 2>/dev/null)"

if [ -z ${JAVA_OPTS} ]; then
    JAVA_OPTS=""
fi
SELENIUM_SERVER_OPTS="\${@}"
SELENIUM_SERVER_DIR="\${SCRIPT_CUR_DIR}/../share"
SELENIUM_SERVER_FILE="${LCL_PKG_FULL_NAME}"
SELENIUM_SERVER_FILE_PATH="\${SELENIUM_SERVER_DIR}/\${SELENIUM_SERVER_FILE}"

java \${JAVA_OPTS} -jar \${SELENIUM_SERVER_FILE_PATH} \${SELENIUM_SERVER_OPTS}
EOF

chmod -v 755 ${PREFIX}/bin/selenium-server-standalone || exit 1;

