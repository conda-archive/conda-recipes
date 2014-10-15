sed -i -e "s:/usr/local:$PREFIX:g" man2html
mkdir $PREFIX/bin
cp man2html $PREFIX/bin
