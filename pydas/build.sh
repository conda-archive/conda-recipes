export CC=${PREFIX}/bin/gcc
export CXX=${PREFIX}/bin/g++
export F77=${PREFIX}/bin/gfortran
wget -P daspk31 http://www.cs.ucsb.edu/~cse/Software/daspk31.tgz
make
$PYTHON setup.py daspk install
