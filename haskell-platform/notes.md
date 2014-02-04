You have to have haskell already installed to build this. Make sure to install
haskell-platform-prof on Linux, not just cabal or ghc.

If you see

    Could not find module `Prelude'
    Perhaps you haven't installed the profiling libraries for package `base'?
    Use -v to see a list of the files searched for.

try using cabal to install the package in question.
