xcopy include\* "%PREFIX%\Library\include\" /E
IF %ARCH%==64 (
    xcopy lib64\* "%PREFIX%\Library\lib\" /E
    xcopy bin64\*.dll "%PREFIX%\Scripts\" /E
    )
IF %ARCH%==32 (
    xcopy lib\* "%PREFIX%\Library\lib\" /E
    xcopy bin\*.dll "%PREFIX%\Scripts\" /E
    )
