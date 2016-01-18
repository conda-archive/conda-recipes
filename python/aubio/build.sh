make checkwaf
python waf configure --prefix=$PREFIX --disable-samplerate --disable-sndfile --disable-avcodec --disable-fftw3 --disable-jack
python waf build
python waf install
pushd python/
python setup.py build
python setup.py install
popd
