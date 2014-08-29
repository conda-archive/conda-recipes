This requires a newish gcc to build. gcc 4.7 will work.

We do not require gcc as a build dependency because we want to make sure that
conda build finds all the files installed for this gcc when creating the
package. So you will need to make sure that the gcc is on the PATH
independently.

On OS X, the dylibs libgcc_ext.10.4.dylib and libgcc_ext.10.5.dylib are Mach-O
stub files, which install_name_tool cannot modify. So we have to use the
binary replacement to change the RPATH in those files, and in a few other
dylibs that pull in the paths from those files.
