:: make sure we pick up the right qmake:
set PATH=%PREFIX%\Scripts;%PATH%

%PYTHON% configure.py ^
        --verbose ^
        --confirm-license ^
        --assume-shared ^
        --bindir=%PREFIX%\Scripts

jom
nmake install
