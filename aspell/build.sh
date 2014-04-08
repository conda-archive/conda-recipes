if (("$(expr "$PREFIX" : '.*')" < 100)); then
    echo "###################################"
    echo "It is recommended to build this package from an Anaconda/Miniconda
installation with a very long prefix. It will not be installable into a
shorter prefix."
    exit 1
fi

# Save placeholder for pre-link.sh. We use .a so that conda won't replace it
# with its normal placeholder.
echo "$PREFIX" > "$PREFIX/.aspell_placeholder.a"

./configure --prefix="$PREFIX"
make
make install
