#!/bin/bash

# Build dependencies:
# - java-1.7.0-openjdk-devel
# - appropriately setup JAVA_HOME variable in system

#unzip ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.zip

mkdir -vp ${PREFIX}/bin;
mkdir -vp ${PREFIX}/share;

export JAVA_HOME="/usr/lib/jvm/java"
export JRE_HOME="/usr/lib/jvm/jre"

cat > ${PREFIX}/bin/mvn <<EOF
#!/bin/bash

CWD="\$(cd "\$(dirname "\${0}")" && pwd -P)"
export M2_HOME="\$(cd "\${CWD}/../share/${PKG_NAME}" && pwd -P)"
export M2="\${M2_HOME}/bin"
export MAVEN_OPTS="-Xms256m -Xmx512m"

echo -e ""
echo -e "Setting up M2_HOME for mvn to \${M2_HOME} ..."
echo -e "Launching mvn ..."
echo -e ""
\${M2}/mvn "\${@}"
EOF

chmod 755 ${PREFIX}/bin/mvn || exit 1;

cp -var ${SRC_DIR}/ ${PREFIX}/share || exit 1;

pushd ${PREFIX}/share || exit 1;
ln -sv ${PKG_NAME}-${PKG_VERSION} ${PKG_NAME} || exit  1;
popd || exit 1;

chmod 755 ${PREFIX}/share/${PKG_NAME}/bin/* || exit 1;

