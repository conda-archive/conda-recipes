
#cp $SRC_DIR/cairocffi/test_cairo.py ./
sed -e "s/^from . import/from cairocffi import/g" -e "s/^from \./from cairocffi./g" $SRC_DIR/cairocffi/test_cairo.py > test_cairo.py
nosetests -P test_cairo.py
