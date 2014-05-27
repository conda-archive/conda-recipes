cmd /c bootstrap msvc
b2 --prefix=%PREFIX% --build-type=complete --with-python --with-signals  --toolset=msvc install
