verify bogus-argument 2>nul
setlocal enableextensions enabledelayedexpansion
if errorlevel 1 (
    echo error: unable to enable command extensions
    exit /b 1
)

if not defined PREFIX (
    rem PREFIX is always defined when conda build calls us... however,
    rem it's handy being able to call bld.bat manually without having
    rem to wait for the whole hg working copy to be checked out again.
    set PREFIX=%HOME%\Anaconda
    set PY_VER=2.7
    set SRC_DIR=%CD%
    set ARCH=64
    set PY3K=0
)


if %ARCH%==64 (
    set CPU=AMD64
    set VCCPU=x86_amd64
) else (
    set CPU=i386
    set VCCPU=x86
)

set VIM=%PREFIX%\vim
set VIM74=%VIM%\vim74
mkdir %VIM%
mkdir %VIM74%

xcopy %RECIPE_DIR%\vim.bat %SCRIPTS%
xcopy %RECIPE_DIR%\gvim.bat %SCRIPTS%
xcopy %RECIPE_DIR%\gvimdiff.bat %SCRIPTS%
xcopy %RECIPE_DIR%\gview.bat %SCRIPTS%
xcopy %RECIPE_DIR%\evim.bat %SCRIPTS%

xcopy %RECIPE_DIR%\_gvimrc %VIM%

xcopy /si %RECIPE_DIR%\vimfiles\doc %VIM74%\doc
xcopy /si %RECIPE_DIR%\vimfiles\colors %VIM74%\colors
xcopy /si %RECIPE_DIR%\vimfiles\plugin %VIM74%\plugin
xcopy /si %RECIPE_DIR%\vimfiles\nerdtree_plugin %VIM74%

rem Remove the . from the Python version; vim only wants 27/33 etc.
set PYVER=%PY_VER:.=%

cd %SRC_DIR%\src

if %PY3K%==1 (
    set _PYTHON=PYTHON3
    set _PYTHON_VER=PYTHON3_VER
    call "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat" %VCCPU%
) else (
    set _PYTHON=PYTHON
    set _PYTHON_VER=PYTHON_VER
    call "%VS90COMNTOOLS%\..\..\VC\vcvarsall.bat" %VCCPU%
)

rem DIRECTX=yes enables support for DirectWrite as a renderoption
rem (`:set renderoption=directx`), which, after much investigation,
rem is what allowed Sublime to render such pretty text, even over
rem Citrix connections.  You'll need to have the DirectX SDK installed
rem for this to work (I installed the Windows 8.1 SDK).  (I wonder if
rem we're allowed to redistribute the headers; being able to do something
rem like `conda install winsdk-headers` would be nice (as it could be
rem included as a dependency in meta.yaml).)
set SDK=C:\Program Files (x86)\Windows Kits\8.1
rem Make sure we use short names with no spaces for the SDK -Is.
for /d %%p in ("%SDK%") do (
    set CVARS=-I%%~sp\Include\shared -I%%~sp\Include\um
)

nmake                       ^
    /nologo                 ^
    -f Make_mvc.mak         ^
    CPU=%CPU%               ^
    IME=yes                 ^
    GUI=yes                 ^
    OLE=yes                 ^
    CSCOPE=yes              ^
    DIRECTX=yes             ^
    DYNAMIC_PYTHON=yes      ^
    %_PYTHON%=%PREFIX%      ^
    %_PYTHON_VER%=%PYVER%   ^
    all

if errorlevel 1 exit /b 1


xcopy /sq ..\runtime\* %VIM74%
xcopy gvim.exe %VIM74%
xcopy gvim.pdb %VIM74%
xcopy vimtbar.dll %VIM74%
xcopy install.exe %VIM74%
xcopy uninstal.exe %VIM74%
xcopy vimrun.exe %VIM74%
xcopy xxd\xxd.exe %VIM74%
xcopy GvimExt\gvimext.dll %VIM74%

rem May as well do a console build whilst we're here.
nmake                       ^
    /nologo                 ^
    -f Make_mvc.mak         ^
    CPU=%CPU%               ^
    IME=yes                 ^
    GUI=no                  ^
    OLE=no                  ^
    CSCOPE=yes              ^
    DIRECTX=yes             ^
    DYNAMIC_PYTHON=yes      ^
    %_PYTHON%=%PREFIX%      ^
    %_PYTHON_VER%=%PYVER%   ^
    vim.exe

if errorlevel 1 exit /b 1

copy vim.exe %VIM74%
copy vim.pdb %VIM74%


rem vim:set ts=8 sw=4 sts=4 tw=78 et:
