This requires a newish gcc to build. gcc 4.7 will work.

We do not require gcc as a build dependency because we want to make sure that
conda build finds all the files installed for this gcc when creating the
package. So you will need to make sure that the gcc is on the PATH
independently.
