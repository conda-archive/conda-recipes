:: may need to change these depending on environment:
CALL "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" amd64

%PYTHON% configure.py ^
    --platform win32-msvc2008 ^
    --bindir=%PREFIX%\Scripts

nmake
nmake install
