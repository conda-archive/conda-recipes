For Windows, see
https://github.com/jyypma/nloptr/blob/master/INSTALL.windows. We have to build
nlopt with nloptr on Winodws.

You will need to install bash, which doesn't come with RTools. Don't use
win-bash. nloptr recommends using msys. You probably shouldn't install any
compilers with mingw, as they could break the compilers from RTools.

You will need to put msys on the front of your PATH (in front of RTools), as
the RTools's sed doesn't work.

If you get an error about creating /tmp, run `mkdir /tmp` inside bash.

You may need to download a newer config.guess file, as instructed.

The Windows build for this package will not work if there are spaces in the
path (I couldn't figure out how to work around it).

Update: I'm looking to replace all this with MSYS2, but it's in
progress. The gist currently is install MSYS2 and no compilers to the default
location. r-rtools is a conda package which you need to install yourself for
now. This will be added as a build dependency in future once conda skeleton
learns about it.
