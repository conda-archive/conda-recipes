cmd /c bootstrap
b2 address-model=%ARCH% --prefix=%PREFIX% --build-type=complete --with-python --with-signals  --toolset=msvc install
