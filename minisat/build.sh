export MROOT=$SRC_DIR
cd core
make rs
cd ..
cd simp
make rs
cd ..
mkdir -p $PREFIX/bin
cp minisat_static $PREFIX/bin/minisat
