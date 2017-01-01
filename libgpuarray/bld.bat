cmake -G"NMake Makefiles" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_C_FLAGS="-I%LIBRARY_PREFIX%\include" ^
      "%SRC_DIR%"
jom -U VERBOSE=1
jom -U install VERBOSE=1
:: cmake --build . --config Release --target ALL_BUILD -- /v:diagnostic
:: cmake --build . --config Release --target install -- /v:diagnostic
