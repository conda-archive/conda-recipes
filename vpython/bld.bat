REM Set up environment for building with MSVC

if %ARCH% == "32" (
    call "C:\Program Files\Microsoft Visual Studio 9.0\Common7\Tools\vsvars32.bat"
    set PROJECT_FILE="cvisual27-32bit.vcproj"
    set PLATFORM=Win32
) else (
    set PROJECT_FILE="cvisual27.vcproj"
    set PLATFORM=x64
)

set INCLUDE="%PREFIX%\include\boost-1_55";"%PREFIX%"\include;"%PREFIX%\lib\site-packages\numpy\core\include";%INCLUDE%
set LIB="%PREFIX%\libs";"%PREFIX%\lib";%LIB%

cd %SRC_DIR%
msbuild VCBuild\%PROJECT_FILE% /property:Configuration=Release /property:Platform=%PLATFORM% /p:"VCBuildAdditionalOptions=/useenv"
if errorlevel 1 exit 1

xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\visual  "%PREFIX%"\lib\site-packages\visual
xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\vis  "%PREFIX%"\lib\site-packages\vis
xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\visual_common  "%PREFIX%"\lib\site-packages\visual_common
xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\vidle2  "%PREFIX%"\lib\site-packages\vidle

