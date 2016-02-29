if [[ "$(uname)" == "Darwin" ]]; then
  # CC=clang otherwise:
  # error: ambiguous instructions require an explicit suffix (could be 'filds', or 'fildl')
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66509
  export CC=clang
fi

./configure --prefix=$PREFIX

make
make check
make install
