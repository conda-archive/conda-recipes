cabal install alex happy
cabal install --only-dependencies
cabal install hsb2hs  # a required build tool
cabal install --flags="embed_data_files" citeproc-hs
cabal configure --flags="embed_data_files"
cabal build
cp dist/build/pandoc $PREFIX/bin
