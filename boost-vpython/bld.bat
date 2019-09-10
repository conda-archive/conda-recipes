REM It seems like bootstrap is easily confused -- without the line below it complains
REM that it cannot find VCVARS32.bat when building 64bit on 64bit, which it shouldn't even need.
if %ARCH% == 64 (
	call "\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\vcvarsx86_amd64.bat"
)
cmd /c bootstrap
b2 address-model=%ARCH% --prefix=%PREFIX% --build-type=complete --with-python --with-signals  --toolset=msvc install
