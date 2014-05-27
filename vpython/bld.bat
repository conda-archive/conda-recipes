REM Set up environment for building with MSVC

call "C:\Program Files\Microsoft Visual Studio 9.0\Common7\Tools\vsvars32.bat"

set INCLUDE="%PREFIX%\include\boost-1_55";"%PREFIX%"\include;"%PREFIX%\lib\site-packages\numpy\core\include";%INCLUDE%
set LIB="%PREFIX%\libs";"%PREFIX%\lib";%LIB%

cd %SRC_DIR%
msbuild VCBuild\cvisual27-32bit.vcproj /property:Configuration=Release /property:Platform=Win32 /p:"VCBuildAdditionalOptions=/useenv"
if errorlevel 1 exit 1

xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\visual  "%PREFIX%"\lib\site-packages\visual
xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\vis  "%PREFIX%"\lib\site-packages\vis
xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\visual_common  "%PREFIX%"\lib\site-packages\visual_common
xcopy /S /Y /I /Q "%SRC_DIR%"\site-packages\vidle2  "%PREFIX%"\lib\site-packages\vidle

