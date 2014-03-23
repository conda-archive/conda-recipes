You have to have haskell already installed to build this. Make sure to install
haskell-platform-prof on Linux, not just cabal or ghc.

Edit ~/.cabal/config and change

    -- library-profiling: False

to

    library-profiling: True

If you see

    Could not find module `Prelude'
    Perhaps you haven't installed the profiling libraries for package `base'?
    Use -v to see a list of the files searched for.

try using cabal to install the package in question. You may need to use
`--reinstall --force-reinstalls` to make it reinstall with profiling support.
