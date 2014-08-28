CALL "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64

:: make sure we pick up the right qmake:
set PATH=%PREFIX%\Scripts;%PATH%

%PYTHON% configure.py ^
        --assume-shared ^
        --verbose ^
        --confirm-license ^
        --bindir=%PREFIX%\Scripts

jom
nmake install
