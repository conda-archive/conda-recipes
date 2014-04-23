export JAVA_HOME=$(/usr/libexec/java_home -v 1.8) # 1.7 is also fine
./build.sh languagetool-standalone clean package

# There doesn't seem to be a recommended place to install it, so
# $PREFIX/languagetool seems good enough.
mv languagetool-standalone/target/LanguageTool-2.6-SNAPSHOT/LanguageTool-2.6-SNAPSHOT $PREFIX/languagetool

git describe | sed 's/-/_/g' > __conda_version__.txt
