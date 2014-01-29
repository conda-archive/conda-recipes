cabal install --flags="embed_data_files" citeproc-hs
cabal configure --flags="embed_data_files"
cabal build
cp dist/build/pandoc $PREFIX/bin

exit 1
