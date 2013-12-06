if [ `uname` != Darwin ]; then
    echo "This recipe only supports OS X for now."
    exit 1
fi

echo "Mounting the disk image"
DMG=`ls $SRC_DIR`
MOUNT_POINT=`hdiutil attach $DMG| tail -n 1 | cut -f 1 -d" "`
MOUNT_LOCATION=`mount | grep $MOUNT_POINT | cut -d" " -f 3`

# Trying to get the installer to do what we want is a PITA. Just extract the
# package and copy the files. You can check that the installer is not doing
# anything extra from this, except for linking the binary, which we don't need
# to worry about here.

echo "Expanding the package"
pkgutil --expand $MOUNT_LOCATION/Vagrant.pkg vagrant

echo "Unpacking the payload"
mkdir work
cd work
cpio -i -I ../vagrant/core.pkg/Payload

echo "Installing the files"
# Not sure where else to put this
mkdir $PREFIX/vagrant
mkdir $PREFIX/bin
cp -R -p * $PREFIX/vagrant
ln -s $PREFIX/vagrant/bin/vagrant $PREFIX/bin/vagrant

echo "Unmounting the disk image"
hdiutil detach $MOUNT_LOCATION
