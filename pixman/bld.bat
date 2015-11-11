:: -- Comnpiling
:: SSSE3 and MMX are giving erros on MSVC 9, so we are
:: disabling them
make -f Makefile.win32 SSSE3=off MMX=off

:: -- Installing
mkdir %LIBRARY_INC%\pixman
move pixman\pixman.h %LIBRARY_INC%\pixman
move pixman\pixman-version.h %LIBRARY_INC%\pixman

move pixman\release\pixman-1.lib %LIBRARY_LIB%
