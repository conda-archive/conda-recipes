Building a conda qt5 package is a slow process. Its a big package, and it takes
a long time to even unpack the compressed source. Its also not possible for
conda to use a git checkout, because conda caches a bare repository, almost
all of the source exists as submodules, and conda tries to clone the submodules
from nonexistent directories in its cache. So we are stuck with the compressed
source files.

## Packages needed to build with RHEL6

- xcb-util-devel

These may have been optional

- libudev-devel
- pcre-devel
- mesa-libEGL

## Notes concerning OS X

- I found it necessary to uninstall the qt4-mac macports package. Qt5 was
  picking up Qt4 headers.
- Found apparent race conditions when running make with multiple jobs.

## Notes concerning Windows:

- It is possible to build Qt5 with MSVC2008, but I have not been successful
  building ICU with MSVC2008. The readme.html in ICU's sources explain how to
  build with older MSVC via cygwin, but I have not been successful. Riverbank
  Computing does not provide PyQt5 installers for python2.7 on windows, due
  to the lack of MSVC2008 support. It seems unwise to distribute PyQt5 for py27
  without upstream support.

- Building from source requires preparing the environment outside conda
  (see http://qt-project.org/doc/qt-5/windows-requirements.html):

    * ActivePerl
    * Ruby
    * Python (trivial)
    * DirectX SDK (if omitting `-opengl desktop` config argument)
    * Visual C++ 2010:

      1. Install Visual Studio 2010
      2. Install Windows SDK 7.1
      3. Install Visual Studio 2010 SP1
      4. Install Visual C++ 2010 SP1 Compiler Update for the Windows SDK 7.1
      5. Copy glext.h, wglext.h, and glxext.h from
         http://www.opengl.org/registry/ into
         `C:\Program Files\ Microsoft SDKs\Windows\v7.1\Include\gl`

  You may also have to make sure perl and ruby can be found on the `%PATH%`. I
  also installed openssl and grep for windows. OpenSSL was necessary for
  PyQt-5.3.1 (but should not be for PyQt-5.3.2). The instructions at
  http://trac.webkit.org/wiki/BuildingQtOnWindows were especially helpful, and
  include links to build dependencies.

  This recipe assumes the computer on which Qt-5 will be installed has drivers
  supporting opengl. It could be rebuilt removing the `-opengl desktop` config
  parameter to use ANGLE, which ships with the qt5 sources.