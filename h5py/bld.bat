REM h5py expects hdf5 libraries to have h5py prefix so make a copy of the hdf5 .lib
REM see https://github.com/h5py/h5py/blob/master/windows/cacheinit.cmake#L14

copy %LIBRARY_LIB%\libhdf5.lib %LIBRARY_LIB%\h5py_hdf5.lib
copy %LIBRARY_LIB%\libhdf5_hl.lib %LIBRARY_LIB%\h5py_hdf5_hl.lib

REM h5py autodection fails on Windows so set directory and version
set HDF5_DIR=%LIBRARY_PREFIX%
set HDF5_VERSION=1.8.13

python setup.py install
if errorlevel 1 exit 1

del %LIBRARY_LIB%\h5py_hdf5.lib
del %LIBRARY_LIB%\h5py_hdf5_hl.lib
