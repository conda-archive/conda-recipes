if "%ARCH%"=="32" (set PY_ARCH=i686) else (set PY_ARCH=x86_64)
openturns-1.5rc1-py2.7-%PY_ARCH%.exe /userlevel=1 /S /FORCE /D=%PREFIX%
