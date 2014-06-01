#!/bin/sh

make

# In order for conda to detect what you've built, you need to copy it into the
# relevant directory in $PREFIX (the non-absolute paths below will be relative
# to the root of the source tree):
cp -rpv out/*.a $PREFIX/lib

# Ditto for the headers.  I noticed a util.h which is a bit too generic to be
# copied into $PREFIX/include directly, so stash stuff in a scs subdir.
mkdir $PREFIX/include/scs
cp -rpv include/*.h $PREFIX/include/scs

# To build/include the Python part you'd do something like:
#$PYTHON setup.py install
# Although it would probably be better to separate the C lib from the Python
# binding (i.e. have two separate conda packages, with the Python recipe pyscs
# depending on the scs C lib).  Actually, the above line may not even work
# *unless* you do it like that.
