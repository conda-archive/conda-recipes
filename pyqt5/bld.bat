:: may need to change these depending on environment:
::CALL "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x6
CALL "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" amd64

:: make sure we pick up the right qmake:
set PATH=%PREFIX%\Scripts;%PATH%

%PYTHON% configure.py ^
        --verbose ^
        --confirm-license ^
        --assume-shared ^
        --bindir=%PREFIX%\Scripts

jom
nmake install
