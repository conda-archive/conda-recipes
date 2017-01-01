set LIB=%LIBRARY_LIB%;%LIB%
set INCLUDE=%LIBRARY_INC%;%INCLUDE%
%PYTHON% setup.py install --single-version-externally-managed --record=record.txt
