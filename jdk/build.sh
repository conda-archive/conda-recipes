#!/bin/bash

#### Download ####
# Check if we're on OS X
if [ -z "$MACOSX_DEPLOYMENT_TARGET" ]; then
	# Download by setting cookie
	curl -b gpw_e24=http%3A%2F%2Fwww.oracle.com -o jdk.dmg -L 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg'‌​

	# Extract files like in
	# http://stackoverflow.com/questions/15217200/how-to-install-java-7-on-mac-in-custom-location
	hdiutil attach -mountpoint jdk_mount jdk.dmg
	pkgutil --expand jdk_mount/JDK\ 7\ Update\ 51/JDK\ 7\ Update\ 51.pkg java
	cat java/jdk17051.pkg/Payload | cpio -zi
	mv Contents/Home "$PREFIX/java"
else
	# Download architecture-specific version (by setting cookie)
	if ["$ARCH" eq "32"]; then
		curl -b gpw_e24=http%3A%2F%2Fwww.oracle.com -o jdk.tar.gz -L 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-i586.tar.gz'
	else
		curl -b gpw_e24=http%3A%2F%2Fwww.oracle.com -o jdk.tar.gz -L 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz'‌​
	fi

	# Extract files
	tar -xzvf jdk.tar.gz
	mv WHATEVERTHEDIRECTORYISCALLED "$PREFIX/java"
fi

# Make symlinks so that things are in the prefix's bin directory
ls "$PREFIX/java/bin/*" | xargs -I{} ln "$PREFIX/java/bin/{}" "$PREFIX/bin/{}"
