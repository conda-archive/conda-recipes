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
