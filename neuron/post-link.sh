link_files () {
    echo "Linking files from $1 to $2" >> $PREFIX/.messages.txt
    
    for f in $1/*; do
        f_basename="${f##*/}"
        f_dest=$2/$f_basename
        echo "Analyzing file $f_dest" >> $PREFIX/.messages.txt
        if [ -f $f_dest ]; then
            echo "$f_dest does exist. Removing for linking" >> $PREFIX/.messages.txt
            rm $f_dest
        fi
        ln -sv $f $f_dest
    done    
}

#link_files ${PREFIX}/x86_64/lib ${PREFIX}/lib
#link_files ${PREFIX}/x86_64/bin ${PREFIX}/bin


