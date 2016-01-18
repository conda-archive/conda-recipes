cd TPL/libsvm-3.1-custom

mkdir windows

nmake -f Makefile.win lib

MOVE windows\libsvm.lib %LIBRARY_LIB%\
MOVE windows\libsvm.dll %LIBRARY_BIN%\

MOVE python\svm.py %SP_DIR%\
MOVE python\svmutil.py %SP_DIR%\

MOVE svm.h %LIBRARY_INC%\
