#!/bin/bash

#### Download in build because we have to set cookies ####
if [ "$ARCH" = "32" ]; then
	curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" -b gpw_e24=http%3A%2F%2Fwww.oracle.com -o jdk.tar.gz -L 'http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-i586.tar.gz'
	lib="i386"
else
	curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" -b gpw_e24=http%3A%2F%2Fwww.oracle.com -o jdk.tar.gz -L 'http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz'
	lib="amd64"
	# jdk/lib/amd64/
	# jdk/lib/amd64/jli/
fi

# Extract files
tar -xzvf jdk.tar.gz
mv jdk1.8.0_77 "$PREFIX/jdk"

# Make symlinks so that things are in the prefix's bin directory
mkdir -p "$PREFIX/bin"
cd "$PREFIX/bin"
for filename in ../jdk/bin/*; do
	ln -s $filename $(basename $filename)
done

# Make symlinks so that things are in the prefix's lib directory
mkdir -p "$PREFIX/lib"
cd "$PREFIX/lib"
for filename in ../jdk/lib/${lib}/* ../jdk/lib/${lib}/jli/*; do
	ln -s $filename $(basename $filename)
done
