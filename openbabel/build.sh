
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DPYTHON_LIBRARY=$PREFIX/lib/libpython$PY_VER.dylib \
      -DPYTHON_EXECUTABLE=$PYTHON \
      -DPYTHON_INCLUDE_DIR=$PREFIX/include/python${PY_VER} \
      -DPYTHON_BINDINGS=ON \
      -DRUN_SWIG=ON

# false # pause here to see what's going on

#put libxml, eigen, wxwidgets, 
make -j${CPU_COUNT}
make install

#The python library and shared object do not install into site-packages so
#we put them there manually after the build.  This may be possible from CMake
#using option -DPYTHON_PREFIX from ob wiki, but doesn't seem to work

cd scripts/python
python setup.py install

#$PREFIX/lib
#mv openbabel.py python${PY_VER}/site-packages/openbabel.py
#mv _openbabel.so python${PY_VER}/site-packages/_openbabel.so
#mv pybel.py python${PY_VER}/site-packages/pybel.py