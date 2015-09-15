for f in ${PREFIX}/x86_64/lib/*; do
    f_basename="${f##*/}"
    f_dest=${PREFIX}/lib/$f_basename
    echo "Analyzing file $f_dest" >> $PREFIX/.messages.txt
    if [ ! -f $f_dest ]; then
        echo "$f_dest does not exist. Linking" >> $PREFIX/.messages.txt
        ln -sv $f $f_dest
    fi
done
