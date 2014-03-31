if [ ! -e "$PREFIX/conda-meta/aspell-[!0123456789]*" ]; then
    echo "Note: The aspell package does not come with any dictionaries. You should
install at least one dictionary, e.g., aspell-en." > "$PREFIX/.messages.txt"
fi
