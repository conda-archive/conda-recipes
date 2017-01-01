#!/bin/bash -eu

VERSION=$($PYTHON $SRC_DIR/setup.py --version)
echo "VERSION=$VERSION"

patch -p1 < $RECIPE_DIR/ordereddict_test.patch

rm -f $SRC_DIR/setup.py
rm -f $SRC_DIR/ext/_ruamel_yaml.c

mkdir $SRC_DIR/ruamel_yaml
mv $SRC_DIR/*.py $SRC_DIR/ruamel_yaml/

sed -i -e 's/_ruamel_yaml/ruamel_yaml\.ext\._ruamel_yaml/g' $SRC_DIR/ruamel_yaml/cyaml.py
sed -i -e 's/ruamel\.yaml/ruamel_yaml/g' $(find $SRC_DIR/. -name \*.py -type f)
sed -i -e 's/from ruamel\.yaml/from ruamel_yaml/g' $SRC_DIR/ext/_ruamel_yaml.pyx
sed -i -e 's/_ruamel_yaml/ruamel_yaml\.ext\._ruamel_yaml/g' $(find $SRC_DIR/_test -name \*.py -type f)

mv $SRC_DIR/ext $SRC_DIR/ruamel_yaml/
touch $SRC_DIR/ruamel_yaml/ext/__init__.py

cp $RECIPE_DIR/setup.py $SRC_DIR/
cp $RECIPE_DIR/__init__.py $SRC_DIR/ruamel_yaml/
sed -i -e 's/__version__.*/__version__ = "$VERSION"/' $SRC_DIR/ruamel_yaml/__init__.py
