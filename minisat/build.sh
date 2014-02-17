export MROOT=$SRC_DIR
# We can also use core
cd simp
make rs
mkdir -p $PREFIX/bin
cp minisat_static $PREFIX/bin/minisat
