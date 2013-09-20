REM h5py expects hdf5dll18.lib, so make a copy of the hdf5 .lib
copy %LIBRARY_LIB%\hdf5.lib %PREFIX%\libs\hdf5dll18.lib
copy %LIBRARY_LIB%\hdf5_hl.lib %PREFIX%\libs\hdf5_hldll.lib

set HDF5_DIR=%LIBRARY_PREFIX%

python setup.py install
if errorlevel 1 exit 1

del %PREFIX%\libs\hdf5*
