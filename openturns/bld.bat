openturns-1.3-py27-x86.exe /S /D="%PREFIX%" /userlevel=1

rem Dirty fix for some Windows install that miss libiconv-2.dll
rem This should be part of the win binary package for the next
rem 1.4 release
copy %RECIPE_DIR%\libiconv-2.dll %LIBRARY_PREFIX%\Lib\site-packages\openturns\

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
