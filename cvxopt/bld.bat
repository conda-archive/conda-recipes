:: move setup.py setup.orig
:: cat %RECIPE_DIR%\mkl_conf.py setup.orig >setup.py
set MINGW_PREFIX=%PREFIX%\Library\mingw-w64

:: There is an incompatibility between the mingw-w64 suitespare and CVXOPT. It
:: concerns include/umfpack_symbolic.h's umfpack_di_symbolic() 3rd and 4th
:: parameters (const int Ap [ ], const int Ai [ ] and cvxopt.h's
:: #define int_t     Py_ssize_t. Here Py_ssize_t is 8 bytes.
:: The umfpack_dl_symbolic function should be used instead, but it is not.
curl -SLO http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.5.tar.gz
tar -xf SuiteSparse-4.5.5.tar.gz
set CVXOPT_SUITESPARSE_SRC_DIR=%CD%\SuiteSparse

if "%NOMKL%" == "0" goto USING_MKL
set CVXOPT_BLAS_LIB=openblas
set CVXOPT_LAPACK_LIB=openblas
set CVXOPT_BUILD_GSL=1
set CVXOPT_BUILD_FFTW=1
set CVXOPT_BUILD_DSDP=1
set CVXOPT_BUILD_GLPK=1
set CVXOPT_GSL_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_GSL_INC_DIR=%MINGW_PREFIX%\include
set CVXOPT_FFTW_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_FFTW_INC_DIR=%MINGW_PREFIX%\include
set CVXOPT_GLPK_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_GLPK_INC_DIR=%MINGW_PREFIX%\include
set CVXOPT_DSDP_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_DSDP_INC_DIR=%MINGW_PREFIX%\include\dsdp
set CVXOPT_SUITESPARSE_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_SUITESPARSE_INC_DIR=%MINGW_PREFIX%\include
goto NOT_USING_MKL
:USING_MKL
set CVXOPT_BUILD_GSL=1
set CVXOPT_BUILD_FFTW=1
set CVXOPT_BUILD_DSDP=1
set CVXOPT_BUILD_GLPK=1
set CVXOPT_GSL_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_GSL_INC_DIR=%MINGW_PREFIX%\include
set CVXOPT_FFTW_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_FFTW_INC_DIR=%MINGW_PREFIX%\include
set CVXOPT_GLPK_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_GLPK_INC_DIR=%MINGW_PREFIX%\include
set CVXOPT_DSDP_LIB_DIR=%MINGW_PREFIX%\lib
set CVXOPT_DSDP_INC_DIR=%MINGW_PREFIX%\include\dsdp
:: set CVXOPT_SUITESPARSE_LIB_DIR=%MINGW_PREFIX%\lib
:: set CVXOPT_SUITESPARSE_INC_DIR=%MINGW_PREFIX%\include
:: curl -SLO http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.5.tar.gz
:: tar -xf SuiteSparse-4.5.5.tar.gz
:: set CVXOPT_SUITESPARSE_SRC_DIR=%CD%\SuiteSparse
:NOT_USING_MKL
"%PYTHON%" setup.py build --compiler=mingw32
if errorlevel 1 exit 1

"%PYTHON%" setup.py install
if errorlevel 1 exit 1
