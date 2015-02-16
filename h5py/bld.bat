REM ** h5py expects hdf5dll18.lib, so make a copy of the hdf5 .lib
REM copy %LIBRARY_LIB%\hdf5.lib %PREFIX%\libs\hdf5dll18.lib
REM copy %LIBRARY_LIB%\hdf5_hl.lib %PREFIX%\libs\hdf5_hldll.lib

REM set HDF5_DIR=%LIBRARY_PREFIX%

REM python setup.py install
REM if errorlevel 1 exit 1

REM del %PREFIX%\libs\hdf5*
REM rd /s /q %SP_DIR%\numpy

move %SRC_DIR%\h5py %SP_DIR%
