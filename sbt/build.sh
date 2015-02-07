#!/bin/bash

mkdir -vp ${PREFIX}/bin;
mkdir -vp ${PREFIX}/share/${PKG_NAME}-${PKG_VERSION};

mv -v sbt-launch.jar ${PREFIX}/share/${PKG_NAME}-${PKG_VERSION}/;

cat > ${PREFIX}/bin/sbt <<EOF
#!/bin/bash

JVM_OPTS="-Dfile.encoding=UTF-8 -Xss8M -Xmx2G -XX:MaxPermSize=1024M -XX:ReservedCodeCacheSize=64M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
SBT_REL_DIR="\$(dirname \${0})"
SBT_LAUNCHER="\$(readlink -f \${SBT_REL_DIR}../share/${PKG_NAME}-${PKG_VERSION}/sbt-launch.jar 2>/dev/null)"

java \${JVM_OPTS} -jar \${SBT_LAUNCHER} \${@}

EOF

chmod -v 755 ${PREFIX}/bin/sbt;
