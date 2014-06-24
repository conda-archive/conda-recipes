#!/bin/bash

# Build dependencies:
# - java-1.7.0-openjdk-devel
# - appropriately setup JAVA_HOME variable in system

mkdir -vp ${PREFIX}/bin;
mkdir -vp ${PREFIX}/share;

tar xvzf ${SRC_DIR}/apache-maven-3.2.1-bin.gz

if [ "$(uname)" == "Darwin" ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    export JRE_HOME=$JAVA_HOME/jre
else
    export JAVA_HOME="/usr/lib/jvm/java"
    export JRE_HOME="/usr/lib/jvm/jre"
fi


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
exec \${M2}/mvn "\${@}"
EOF

chmod 755 ${PREFIX}/bin/mvn || exit 1;

cp -va ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION} ${PREFIX}/share || exit 1;

pushd ${PREFIX}/share || exit 1;
ln -sv ${PKG_NAME}-${PKG_VERSION} ${PKG_NAME} || exit  1;
popd || exit 1;

