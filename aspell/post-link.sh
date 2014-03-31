# http://everydaywithlinux.blogspot.com/2012/11/patch-strings-in-binary-files-with-sed.html
function patch_strings_in_file() {
    local FILE="$1"
    local PATTERN="$2"
    local REPLACEMENT="$3"

    # Find all unique strings in FILE that contain the pattern
    STRINGS=$(strings ${FILE} | grep ${PATTERN} | sort -u -r)

    if [ "${STRINGS}" != "" ] ; then
        echo "File '${FILE}' contain strings with '${PATTERN}' in them:"

        for OLD_STRING in ${STRINGS} ; do
            # Create the new string with a simple bash-replacement
            NEW_STRING=${OLD_STRING//${PATTERN}/${REPLACEMENT}}

            # Create null terminated ASCII HEX representations of the strings
            OLD_STRING_HEX="$(echo -n ${OLD_STRING} | xxd -g 0 -u -ps -c 256)00"
            NEW_STRING_HEX="$(echo -n ${NEW_STRING} | xxd -g 0 -u -ps -c 256)00"

            if [ ${#NEW_STRING_HEX} -le ${#OLD_STRING_HEX} ] ; then
                # # Pad the replacement string with null terminations so the
                # # length matches the original string
                while [ ${#NEW_STRING_HEX} -lt ${#OLD_STRING_HEX} ] ; do
                    NEW_STRING_HEX="${NEW_STRING_HEX}00"
                done

                # Now, replace every occurrence of OLD_STRING with NEW_STRING
                echo -n "Replacing ${OLD_STRING} with ${NEW_STRING}... "
                hexdump -ve '1/1 "%.2X"' ${FILE} | \
                sed "s/${OLD_STRING_HEX}/${NEW_STRING_HEX}/g" | \
                xxd -r -p > ${FILE}.tmp
                mv ${FILE}.tmp ${FILE}
                echo "Done!"
            else
                echo "New string '${NEW_STRING}' is longer than old" \
                     "string '${OLD_STRING}'. Skipping."
            fi
        done
    fi
}

PLACEHOLDER_PREFIX=$(cat "$PREFIX/.aspell_placeholder.a" | tr -d '\n')
if (("$(expr "$PLACEHOLDER_PREFIX" : '.*')" < "$(expr "$PREFIX" : '.*')")); then
    echo "The prefix for this installation prefix is too long. It can be no longer
than " "$(expr "$PLACEHOLDER_PREFIX" : '.*')" " characters.  Choose a shorter
prefix or rebuild this package with a longer one."
    exit 1
fi

patch_strings_in_file "$PREFIX/lib/libaspell.dylib" "$PLACEHOLDER_PREFIX" "$PREFIX"
patch_strings_in_file "$PREFIX/lib/libaspell.15.dylib" "$PLACEHOLDER_PREFIX" "$PREFIX"

if [ ! -e "$PREFIX/conda-meta/aspell-[!0123456789]*" ]; then
    echo "Note: The aspell package does not come with any dictionaries. You should
install at least one dictionary, e.g., aspell-en." > "$PREFIX/.messages.txt"
fi
