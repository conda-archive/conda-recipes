# Install gin, gwt, junitjar, selenium, and ChromeDriver for selenium
# (https://github.com/rstudio/rstudio/blob/master/dependencies/common/install-gwt)

BUILD_TOOLS_URL=https://s3.amazonaws.com/rstudio-buildtools/

curl -L $BUILD_TOOLS_URL/gin-1.5.zip > gin-1.5.zip
mkdir -p src/gwt/lib/gin/1.5
unzip -qd gin-1.5.zip src/gwt/lib/gin/1.5

curl -L $BUILD_TOOLS_URL/gwt-2.7.0.zip > gwt-2.7.0.zip
mkdir -p src/gwt/lib/gwt/2.7.0
unzip -qd gwt-2.7.0.zip src/gwt/lib/gwt/2.7.0

curl -L $BUILD_TOOLS_URL/junit-4.9b3.jar > junit-4.9b3.jar
mv junit-4.9b3.jar src/gwt/lib/junit-4.9b3.jar



mkdir build
cd build

export LIBR_HOME=$PREFIX/lib/R
export BOOST_ROOT=$PREFIX
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DRSTUDIO_TARGET=Desktop \
      -DCMAKE_BUILD_TYPE=Release \
      ..

make install
